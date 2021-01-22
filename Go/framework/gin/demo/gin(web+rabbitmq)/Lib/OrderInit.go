package Lib

import "fmt"

func OrderInit() error {
	mq := NewMQ()
	if mq == nil {
		return fmt.Errorf("mq init error")
	}
	defer mq.Channel.Close()
	//申明交换机
	exName := "Exchange_Order"
	err := mq.Channel.ExchangeDeclare(exName, "direct", false, false, false, false, nil)
	if err != nil {
		return fmt.Errorf("Exchange_Order error", err)
	}
	queueName := "Queue_Order"
	err = mq.DecQueueAndBind(queueName, "Key_Order", exName)
	if err != nil {
		return fmt.Errorf("dlx Bind error", err)
	}
	return nil
}
