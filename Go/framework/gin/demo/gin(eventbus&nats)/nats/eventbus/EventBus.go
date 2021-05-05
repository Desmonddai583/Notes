package eventbus

import (
	"fmt"
	"sync"
)

type EventBus struct {
	subscribes map[string][]EventDataChannel
	handlers map[string]*EventHandler
	lock sync.RWMutex
}

func NewEventBus() *EventBus {
	return &EventBus{subscribes: make(map[string][]EventDataChannel),handlers:make(map[string]*EventHandler)}
}
func(this *EventBus) PrintNum(topic string ){
	fmt.Println(len(this.subscribes[topic]))
}

//订阅
func(this *EventBus) Sub(topic string,fn interface{}) EventDataChannel{
	this.lock.Lock()
	defer this.lock.Unlock()
		ec:=make(EventDataChannel)
		this.subscribes[topic]=append(this.subscribes[topic],ec)
	    this.handlers[topic]=NewEventHandler(fn)
		return ec
}

func(this *EventBus) UnSub(topic string,ch EventDataChannel){
	this.lock.Lock()
	defer this.lock.Unlock()
	if _, ok := this.subscribes[topic]; ok && len(this.subscribes[topic]) > 0 {
		this.removeSubscibe(topic, ch)
	}
}
func(this *EventBus) removeSubscibe(topic string,ch EventDataChannel){
	index:=-1
	if ecs,found:=this.subscribes[topic];found{
		for i,ec:=range ecs{
			if ch!=nil && ec==ch{
				index=i
				break
			}
		}
	}
	if index>=0{
		this.subscribes[topic] = append(this.subscribes[topic][:index],
			this.subscribes[topic][index+1:]...)
	}
}



func(this *EventBus) Pub(topic string,ch EventDataChannel,params ...interface{})  {
	this.lock.RLock()
	defer this.lock.RUnlock()
	if ecs,found:=this.subscribes[topic];found{
		handler:=this.handlers[topic]
		for _,ec:=range ecs{
			if ch!=nil && ec==ch{
				go func(inch EventDataChannel) {
					inch<-&EventData{Data:handler.Call(params...)}
				}(ec)
				break
			}
		}



	}

}
