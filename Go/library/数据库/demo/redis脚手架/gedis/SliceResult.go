package gedis

type SliceResult struct {
	Result []interface{}
	Err    error
}

func NewSliceResult(result []interface{}, err error) *SliceResult {
	return &SliceResult{Result: result, Err: err}
}
func (this *SliceResult) Unwrap() []interface{} {
	if this.Err != nil {
		panic(this.Err)
	}
	return this.Result
}
func (this *SliceResult) Unwrap_Or(v []interface{}) []interface{} {
	if this.Err != nil {
		return v
	}
	return this.Result
}
func (this *SliceResult) Iter() *Iterator {
	return NewIterator(this.Result)
}
