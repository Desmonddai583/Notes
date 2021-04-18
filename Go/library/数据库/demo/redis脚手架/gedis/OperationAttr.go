package gedis

import (
	"fmt"
	"time"
)

type empty struct{}

const (
	ATTR_EXPIRE = "expr" //过期时间
	ATTR_NX     = "nx"   // setnx
	ATTR_XX     = "xx"   // setxx
)

//属性
type OperationAttr struct {
	Name  string
	Value interface{}
}
type OperationAttrs []*OperationAttr

func (this OperationAttrs) Find(name string) *InterfaceResult {
	for _, attr := range this {
		if attr.Name == name {
			return NewInterfaceResult(attr.Value, nil)
		}
	}
	return NewInterfaceResult(nil, fmt.Errorf("OperationAttrs found error:%s", name))
}
func WithExpire(t time.Duration) *OperationAttr {
	return &OperationAttr{Name: ATTR_EXPIRE, Value: t}
}
func WithNX() *OperationAttr {
	return &OperationAttr{Name: ATTR_NX, Value: empty{}}
}
func WithXX() *OperationAttr {
	return &OperationAttr{Name: ATTR_XX, Value: empty{}}
}
