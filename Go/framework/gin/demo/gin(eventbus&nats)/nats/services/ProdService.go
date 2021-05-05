package services

import (
	"mypro/eventbus"

	"github.com/gin-gonic/gin"
)

func GetProdListCh() eventbus.EventDataChannel {
	return Bus.Sub(GetList_Prods, NewProdService().GetList)
}

type ProdModel struct {
	Id   int
	Name string
}
type ProdService struct{}

func NewProdService() *ProdService {
	return &ProdService{}
}
func (this *ProdService) GetList(page string) gin.H {
	list := []*ProdModel{
		{Id: 101, Name: "java图书"},
		{Id: 102, Name: "PHP入门到精通"},
	}
	return gin.H{"page": page, "result": list}
}
