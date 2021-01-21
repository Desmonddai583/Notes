package Helper

import (
	"log"

	"rmq.jtthink.com/AppInit"
)

func SetNotify(user_id string, max_retry int) (r int) {
	sql := ` insert into user_notify(user_id,updatetime)
    values(?,now()) ON DUPLICATE KEY UPDATE 
		notifynum=IF(isdone=1,notifynum,notifynum+1),
		isdone=IF(notifynum>=?,1,0),
		 updatetime=IF(isdone=1,updatetime,now())
`
	stmt, err := AppInit.GetDB().Preparex(sql)
	if err != nil {
		log.Println(err)
		return
	}
	defer stmt.Close()
	ret, err := stmt.Exec(user_id, max_retry)
	if err != nil {
		log.Println("fetch notify error:", err)
		return
	}
	rowAffected, err := ret.RowsAffected() //受影响的行 >0 代表继续要发送  =0 代表到了最大次数，不要发送
	if err != nil {
		log.Println("get row error:", err)
		return
	}
	r = int(rowAffected)
	return

}
