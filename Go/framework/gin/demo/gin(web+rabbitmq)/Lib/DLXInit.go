package Lib

import "fmt"

func DLXInit() error {
	mq := NewMQ()
	if mq == nil {
		return fmt.Errorf("mq init error")
	}
	defer mq.Channel.Close()
	//申明交换机
	exName := "Exchange_dlx"
	err := mq.Channel.ExchangeDeclare(exName, "direct", false, false, false, false, nil)
	if err != nil {
		return fmt.Errorf("Exchange_dlx error", err)
	}
	queueName := "queue_dlx"
	args := map[string]interface{}{"x-message-ttl": 3000, "x-dead-letter-exchange": "Exchange_dlx_test",
		"x-dead-letter-routing-key": "dlx"}
	err = mq.DecQueueAndBindWithArgs(queueName, "topic.#", exName, args)
	if err != nil {
		return fmt.Errorf("dlx Bind error", err)
	}
	return nil
}

func DlXTestInit() error {
	mq := NewMQ()
	if mq == nil {
		return fmt.Errorf("mq init error")
	}
	defer mq.Channel.Close()
	//申明交换机
	exName := "Exchange_dlx_test"
	err := mq.Channel.ExchangeDeclare(exName, "direct", false, false, false, false, nil)
	if err != nil {
		return fmt.Errorf("dlx_test error", err)
	}
	queueName := "test_dlx"
	args := map[string]interface{}{}
	err = mq.DecQueueAndBindWithArgs(queueName, "dlx", exName, args)
	if err != nil {
		return fmt.Errorf("dlx Bind error", err)
	}
	return nil
}
