package Models

import "time"

type LogModel struct {
	IP       string    `json:"ip"`
	Status   int       `json:"status"`
	ExecTime int64     `json:"duration"`
	Method   string    `json:"method"`
	Url      string    `json:"url"`
	LogTime  time.Time `json:"time"`
	Level    string    `json:"level"`
	Message  string    `json:"msg"`
}
