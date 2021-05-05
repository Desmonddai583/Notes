package eventbus

import (
	"context"
	"time"

	"github.com/gin-gonic/gin"
)

// 事件数据
type EventData struct {
	Data interface{}
}

// 传递事件数据的通道
type EventDataChannel chan *EventData

func (this EventDataChannel) Data(timeout time.Duration) interface{} {

	ctx, cancle := context.WithTimeout(context.Background(), timeout)
	defer cancle()
	select {
	case <-ctx.Done(): //超时了
		return gin.H{"message": "timeout"}
	case data := <-this:
		return data.Data
	}
}
