package Wrappers

import (
	"context"
	"strconv"

	"github.com/afex/hystrix-go/hystrix"
	"github.com/micro/go-micro/client"
	"gomicro.jtthink.com/Services"
)

func newProd(id int32, pname string) *Services.ProdModel {
	return &Services.ProdModel{ProdID: id, ProdName: pname}
}

//通用降级方法
func defaultData(rsp interface{}) {
	switch t := rsp.(type) {
	case *Services.ProdListResponse:
		defaultProds(rsp)
	case *Services.ProdDetailResponse:
		t.Data = newProd(10, "降级商品")
	}
}

//商品列表降级方法
func defaultProds(rsp interface{}) {
	models := make([]*Services.ProdModel, 0)
	var i int32
	for i = 0; i < 5; i++ {
		models = append(models, newProd(20+i, "prodname"+strconv.Itoa(20+int(i))))
	}
	result := rsp.(*Services.ProdListResponse)
	result.Data = models
}

type ProdsWrapper struct {
	client.Client
}

func (this *ProdsWrapper) Call(ctx context.Context, req client.Request, rsp interface{}, opts ...client.CallOption) error {
	cmdName := req.Service() + "." + req.Endpoint()
	configA := hystrix.CommandConfig{
		Timeout:                2000,
		RequestVolumeThreshold: 2,
		ErrorPercentThreshold:  50,
		SleepWindow:            5000,
	}
	hystrix.ConfigureCommand(cmdName, configA)
	return hystrix.Do(cmdName, func() error {
		return this.Client.Call(ctx, req, rsp)
	}, func(e error) error {
		defaultData(rsp)
		return nil
	})
}
func NewProdsWrapper(c client.Client) client.Client {
	return &ProdsWrapper{Client: c}
}
