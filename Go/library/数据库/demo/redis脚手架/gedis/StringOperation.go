package gedis

import (
	"context"
	"time"
)

//专门处理string类型的操作
type StringOperation struct {
	ctx context.Context
}

func NewStringOperation() *StringOperation {
	return &StringOperation{ctx: context.Background()}
}

func (this *StringOperation) Set(key string, value interface{},
	attrs ...*OperationAttr) *InterfaceResult {
	exp := OperationAttrs(attrs).
		Find(ATTR_EXPIRE).
		Unwrap_Or(time.Second * 0).(time.Duration)

	nx := OperationAttrs(attrs).Find(ATTR_NX).Unwrap_Or(nil)
	if nx != nil {
		return NewInterfaceResult(Redis().SetNX(this.ctx, key, value, exp).Result())
	}
	xx := OperationAttrs(attrs).Find(ATTR_XX).Unwrap_Or(nil)
	if xx != nil {
		return NewInterfaceResult(Redis().SetXX(this.ctx, key, value, exp).Result())
	}
	return NewInterfaceResult(Redis().Set(this.ctx, key, value,
		exp).Result())

}
func (this *StringOperation) Get(key string) *StringResult {
	return NewStringResult(Redis().Get(this.ctx, key).Result())
}
func (this *StringOperation) MGet(keys ...string) *SliceResult {
	return NewSliceResult(Redis().MGet(this.ctx, keys...).Result())
}
