package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"

	"github.com/jmoiron/sqlx"
	"github.com/streadway/amqp"
	"rmq.jtthink.com/Lib"
	"rmq.jtthink.com/Trans"
)

const saveSql = "insert into translog(tid,`from`,`to`,money,updatetime) values(?,?,?,?,now())"
const updateMoney = "update umoney set umoney=umoney+? where uname=?"

func clearTx(tx *sqlx.Tx) { //清理事务
	err := tx.Commit()
	if err != nil && err != sql.ErrTxDone {
		log.Println("tx error:", err)
	}
}
func saveLog(tm *Trans.TransModel) {

	tx, err := Trans.GetDB().BeginTxx(context.Background(), nil)
	if err != nil {
		log.Println("tx error", err)
		return
	}
	defer clearTx(tx)
	_, err = tx.Exec(saveSql, tm.Tid, tm.From, tm.To, tm.Money)
	if err != nil {
		log.Println(err)
		tx.Rollback()
		return
	}
	ret, err := tx.Exec(updateMoney, tm.Money, tm.To) //给钱
	aff, err_aff := ret.RowsAffected()
	if err != nil || err_aff != nil || aff != 1 {
		tx.Rollback()
		return
	}
	err = callBack(tm.Tid) //回调
	if err != nil {
		log.Println("callback error:", err)
		tx.Rollback()
		return
	}
}
func callBack(tid int64) error {
	rsp, err := http.Post("http://localhost:8080/callback",
		"application/x-www-form-urlencoded", strings.NewReader(fmt.Sprintf("tid=%d", tid)))
	if err != nil {
		log.Println(err)
		return err
	}
	defer rsp.Body.Close()
	b, err := ioutil.ReadAll(rsp.Body)
	if err != nil {
		log.Println(err)
		return err
	}
	if string(b) == "success" {
		return nil
	} else {
		return fmt.Errorf("error")
	}
}

func recFromA(msgs <-chan amqp.Delivery, c string) {
	for msg := range msgs {
		tm := Trans.NewTransModel()
		err := json.Unmarshal(msg.Body, tm)
		if err != nil {
			log.Println(err)
		} else {
			go func(t *Trans.TransModel) {
				defer msg.Ack(false)
				saveLog(t)
			}(tm)
		}
	}
}

var myclient *Lib.MQ //暴露myclient
func main() {
	var c *string
	c = flag.String("c", "", "消费者名称")
	flag.Parse()
	if *c == "" {
		log.Fatal("c参数一定要写")
	}
	dberr := Trans.DBInit("b") //DB 初始化
	if dberr != nil {
		log.Fatal("DB error:", dberr)
	}
	myclient = Lib.NewMQ()
	err := myclient.Channel.Qos(2, 0, false)
	if err != nil {
		log.Fatal(err)
	}
	myclient.Consume(Lib.QUEUE_TRANS, *c, recFromA)

	defer myclient.Channel.Close()
}
