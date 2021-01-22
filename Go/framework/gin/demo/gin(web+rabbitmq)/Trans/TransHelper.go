package Trans

import (
	"context"
	"fmt"
	"log"
)

//转账  针对A公司
func TransMoney(tm *TransModel) error {
	tx := GetDB().MustBeginTx(context.Background(), nil)

	ret, _ := tx.NamedExec(`update usermoney set user_money=user_money-:money 
    	  where user_name=:from and user_money>=:money
`, tm)
	rowAffected, _ := ret.RowsAffected()
	if rowAffected == 0 {
		err := tx.Rollback()
		if err != nil {
			log.Println(err)
		}
		return fmt.Errorf("扣款失败")
	}
	ret, _ = tx.NamedExec("insert into translog(`from`,`to`,money,updatetime) "+
		"values(:from,:to,:money,now())", tm)
	rowAffected, _ = ret.RowsAffected()
	if rowAffected == 0 {
		err := tx.Rollback()
		if err != nil {
			log.Println(err)
		}
		return fmt.Errorf("插入日志失败")
	}
	tid, _ := ret.LastInsertId() //赋值tid,tid=交易号
	tm.Tid = tid
	return tx.Commit()
}
