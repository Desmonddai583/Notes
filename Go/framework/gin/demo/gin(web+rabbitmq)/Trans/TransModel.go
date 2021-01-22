package Trans

import (
	"fmt"
	"time"
)

type TransModel struct {
	Tid        int64     `db:"tid"`
	From       string    `json:"from" db:"from"`
	To         string    `json:"to" db:"to"`
	Money      int       `json:"m" db:"money"`
	Status     int       `json:"-" db:"status"`
	Updatetime time.Time `json:"-" db:"updatetime"`
	Isback     []uint8   `json:"-" db:"isback"` //注意这里，bit型  对应的 是[]uint8
}

func NewTransModel() *TransModel {
	return &TransModel{}
}
func (this *TransModel) String() string {
	return fmt.Sprintf("%s转账给%s,金额是:%d\n", this.From, this.To, this.Money)
}
