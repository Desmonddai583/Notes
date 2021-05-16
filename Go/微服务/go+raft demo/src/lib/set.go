package lib

import "sync"

//手撸 Set
type Set struct {
	data sync.Map
}

func NewSet() *Set {
	return &Set{}
}
func (this *Set) Add(v string) {
	this.data.Store(v, struct{}{})
}
func (this *Set) Values() []string {
	ret := make([]string, 0)
	this.data.Range(func(key, value interface{}) bool {
		ret = append(ret, key.(string))
		return true
	})
	return ret
}
