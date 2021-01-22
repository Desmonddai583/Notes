package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"log"

	"github.com/jmoiron/sqlx"
	"github.com/robfig/cron/v3"
	"rmq.jtthink.com/Lib"
	"rmq.jtthink.com/Trans"
)

var MyCron *cron.Cron

func initCron() error {
	MyCron = cron.New(cron.WithSeconds()) //支持秒级定时器
	_, err := MyCron.AddFunc("0/3 * * * * *", FailTrans)
	if err != nil {
		return err
	}
	_, err2 := MyCron.AddFunc("0/4 * * * * *", BackMoney)
	if err2 != nil {
		return err2
	}
	_, err3 := MyCron.AddFunc("0/2 * * * * *", reSendMsg) //重发
	if err3 != nil {
		return err3
	}
	return nil
}

//这里 修改点：status=0
const FailSql = "update translog set STATUS=2 where TIMESTAMPDIFF(SECOND,updatetime,now())>20 and STATUS=0"
const BackSql = "select tid, `from`,money from translog  where status=2 and isback=0 limit 10   "
const resendSql = "select * from translog where status=0 and TIMESTAMPDIFF(SECOND,updatetime,now())<=8 "

//定时取消交易
func FailTrans() {
	_, err := Trans.GetDB().Exec(FailSql)
	if err != nil {
		log.Println(err)
	}
}

var islock = false

func reSendMsg() {
	rows, err := Trans.GetDB().Queryx(resendSql)
	if err != nil {
		log.Println(err)
	}
	transList := []*Trans.TransModel{}
	err = sqlx.StructScan(rows, &transList)
	if err != nil {
		log.Println(err)
	} else {
		mq := Lib.NewMQ()
		for _, tm := range transList {
			jsonb, _ := json.Marshal(tm) //可以使用协程
			err = mq.SendMessage(Lib.ROUTER_KEY_TRANS, Lib.EXCHANGE_TRANS, string(jsonb))
			if err != nil {
				log.Println(err)
			} else {
				log.Println("重发成功:", tm)
			}
		}

	}

}
func clearTx(tx *sqlx.Tx) { //清理事务
	err := tx.Commit()
	if err != nil && err != sql.ErrTxDone {
		log.Println("tx error:", err)
	}
	islock = false
}

//还钱
func BackMoney() {
	if islock {
		log.Println("locked.return.......")
		return
	}
	tx, err := Trans.GetDB().BeginTxx(context.Background(), nil)
	if err != nil {
		log.Println("事务失败:", err)
		return
	}
	islock = true     //加锁
	defer clearTx(tx) //清理事务

	rows, err := tx.Queryx(BackSql)
	if err != nil {
		tx.Rollback()
		return
	}
	defer rows.Close()
	tms := []Trans.TransModel{}
	_ = sqlx.StructScan(rows, &tms)
	for _, tm := range tms {
		_, err = tx.Exec("update usermoney set user_money=user_money+? where user_name=?", tm.Money, tm.From)
		if err != nil {
			tx.Rollback()
		}
		_, err = tx.Exec("update translog set isback=1 where tid=?", tm.Tid)
		if err != nil {
			tx.Rollback()
		}
	}
}

func main() {

	c := make(chan error)
	go func() {
		err := Trans.DBInit("a")
		if err != nil {
			c <- err
		}

	}()
	go func() {
		err := initCron()
		if err != nil {
			c <- err
		}
		MyCron.Start() //开启定时任务
	}()
	err := <-c
	log.Fatal(err)

}
