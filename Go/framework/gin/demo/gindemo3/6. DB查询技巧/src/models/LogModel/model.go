package LogModel

import "time"

//日志实体
type LogImpl struct {
	LogId int `gorm:"column:log_id;type:int;primaryKey;autoIncrement" json:"id" `
	LogName string `gorm:"column:log_name;"  json:"log_name"  `
	LogDate time.Time `gorm:"column:log_date;"  json:"log_date"  `
}

func New(logName string, logDate time.Time) *LogImpl {
	return &LogImpl{LogName: logName, LogDate: logDate}
}
func(*LogImpl) TableName() string{
	return "logs"
}