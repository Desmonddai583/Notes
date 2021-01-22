package models

import "time"

type RequestModel struct {
	UserId    int       `json:"uid"`
	OrderNo   string    `json:"orderno"`
	OrderTime time.Time `json:"ordertime"`
}
