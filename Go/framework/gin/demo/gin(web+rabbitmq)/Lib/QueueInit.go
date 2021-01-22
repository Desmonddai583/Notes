package Lib

import "fmt"

//初始化用户相关的队列
func UserInit() error {
	mq := NewMQ()
	if mq == nil {
		return fmt.Errorf("mq init error")
	}
	defer mq.Channel.Close()
	//申明交换机
	err := mq.Channel.ExchangeDeclare(EXCHANGE_USER, "direct", false, false, false, false, nil)
	if err != nil {
		return fmt.Errorf("Exchange error", err)
	}
	//qs:=fmt.Sprintf("%s,%s",QUEUE_NEWUSER,QUEUE_NEWUSER_UNION)
	qs := fmt.Sprintf("%s", QUEUE_NEWUSER) //这里改动了下，只绑定一个队列
	err = mq.DecQueueAndBind(qs, ROUTER_KEY_USERREG, EXCHANGE_USER)
	if err != nil {
		return fmt.Errorf("Queue Bind error", err)
	}
	return nil

}

func UserDelayInit() error {
	mq := NewMQ()
	if mq == nil {
		return fmt.Errorf("mq init error")
	}
	defer mq.Channel.Close()
	//申明交换机
	err := mq.Channel.ExchangeDeclare(EXCHANGE_USER_DELAY, "x-delayed-message",
		false, false, false, false,
		map[string]interface{}{"x-delayed-type": "direct"})
	if err != nil {
		return fmt.Errorf("DelayExchange error", err)
	}
	qs := fmt.Sprintf("%s", QUEUE_NEWUSER)
	err = mq.DecQueueAndBind(qs, ROUTER_KEY_USERREG, EXCHANGE_USER_DELAY)
	if err != nil {
		return fmt.Errorf("Queue Bind error", err)
	}
	return nil
}

//转账相关队列初始化
func TransInit() error {
	mq := NewMQ()
	if mq == nil {
		return fmt.Errorf("mq init error")
	}
	defer mq.Channel.Close()
	//申明交换机
	err := mq.Channel.ExchangeDeclare(EXCHANGE_TRANS, "direct", false, false, false, false, nil)
	if err != nil {
		return fmt.Errorf("Exchange_Trans error", err)
	}
	err = mq.DecQueueAndBind(QUEUE_TRANS, ROUTER_KEY_TRANS, EXCHANGE_TRANS)
	if err != nil {
		return fmt.Errorf("Queue Bind error", err)
	}
	return nil
}
