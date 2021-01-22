package Lib

import (
	"fmt"
	"log"
	"strings"

	"github.com/streadway/amqp"
	"rmq.jtthink.com/AppInit"
)

const (
	QUEUE_NEWUSER       = "newuser"       //用户注册 对应的队列名称
	QUEUE_NEWUSER_UNION = "newuser_union" //合作单位用户注册 对应的队列名称
	EXCHANGE_USER       = "UserExchange"  //用户模块相关的交换机
	EXCHANGE_USER_DELAY = "UserExchangeDelay"
	ROUTER_KEY_USERREG  = "userreg" //注册用户的路由key

	EXCHANGE_TRANS   = "TransExchange" //转账相关交换机
	ROUTER_KEY_TRANS = "trans"         //转账相关路由key
	QUEUE_TRANS      = "TransQueueA"   //转账相关队列
)

type MQ struct {
	Channel       *amqp.Channel
	notifyConfirm chan amqp.Confirmation
	notifyReturn  chan amqp.Return
}

func NewMQ() *MQ {
	c, err := AppInit.GetConn().Channel()
	if err != nil {
		log.Println(err)
		return nil
	}
	return &MQ{Channel: c}
}

//申明队列以及绑定路由key
//多个队列 可以用逗号分隔
func (this *MQ) DecQueueAndBind(queues string, key string, exchange string) error {
	qList := strings.Split(queues, ",")
	for _, queue := range qList {
		q, err := this.Channel.QueueDeclare(queue, false, false, false, false, nil)
		if err != nil {
			return err
		}
		err = this.Channel.QueueBind(q.Name, key, exchange, false, nil)
		if err != nil {
			return err
		}
	}
	return nil
}
func (this *MQ) DecQueueAndBindWithArgs(queues string, key string, exchange string, args map[string]interface{}) error {
	qList := strings.Split(queues, ",")
	for _, queue := range qList {
		q, err := this.Channel.QueueDeclare(queue, false, false, false, false, args)
		if err != nil {
			return err
		}
		err = this.Channel.QueueBind(q.Name, key, exchange, false, nil)
		if err != nil {
			return err
		}
	}
	return nil
}
func (this *MQ) NotifyReturn() {
	this.notifyReturn = this.Channel.NotifyReturn(make(chan amqp.Return))
	go this.listenReturn() //使用协程执行
}
func (this *MQ) listenReturn() {
	ret := <-this.notifyReturn
	fmt.Println(ret.Headers)
	if string(ret.Body) != "" {
		log.Println("消息没有正确入列:", string(ret.Body))
	}

}
func (this *MQ) SetConfirm() {
	err := this.Channel.Confirm(false)
	if err != nil {
		log.Println(err)
	}
	this.notifyConfirm = this.Channel.NotifyPublish(make(chan amqp.Confirmation))
}
func (this *MQ) ListenConfirm() {
	defer this.Channel.Close()
	ret := <-this.notifyConfirm
	if ret.Ack {
		log.Println("confirm:消息发送成功")
	} else {
		log.Println("confirm:消息发送失败")
	}

}

//发送延迟消息
func (this *MQ) SendDelayMessage(key string, exchange string, message string, delay int) error {
	err := this.Channel.Publish(exchange, key, true, false,
		amqp.Publishing{
			Headers:     map[string]interface{}{"x-delay": delay},
			ContentType: "text/plain",
			Body:        []byte(message),
		},
	)
	return err
}
func (this *MQ) SendMessage(key string, exchange string, message string) error {
	err := this.Channel.Publish(exchange, key, true, false,
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        []byte(message),
		},
	)
	return err
}
func (this *MQ) Consume(queue string, key string, callbak func(<-chan amqp.Delivery, string)) {
	msgs, err := this.Channel.Consume(queue, key, false, false, false, false, nil)
	if err != nil {
		log.Fatal(err)
	}
	callbak(msgs, key)
}
