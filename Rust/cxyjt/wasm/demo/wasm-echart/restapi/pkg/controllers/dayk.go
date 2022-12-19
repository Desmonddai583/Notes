package controllers

import (
	"github.com/gin-gonic/gin"
	"github.com/shenyisyn/goft-gin/goft"
	"gorm.io/gorm"
	"strconv"
	"time"
	"wasmapi/pkg/models"
)

func year(y string) (start, end int) {
	year, err := strconv.Atoi(y)
	if err != nil {
		year = time.Now().Year()
	}
	return year * 10000, (year + 1) * 10000
}

type DayK struct {
	DB *gorm.DB `inject:"-"`
}

func NewDayK() *DayK {
	return &DayK{}
}

func (d *DayK) DataForYear(c *gin.Context) goft.Json {
	tscode := c.Param("tscode")
	year_start, year_end := year(c.Query("year"))
	ret := []*models.DayKModel{}
	d.DB.Raw("select * from dayk where ts_code=? and trade_date>=? and trade_date<=?", tscode, year_start, year_end).
		Order("trade_date").Find(&ret)
	return ret

}
func (r *DayK) Name() string {
	return "DayK"
}

// TODO 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
func (r *DayK) Build(goft *goft.Goft) {
	goft.Handle("GET", "/dayk/:tscode", r.DataForYear)
}
