package Annotation

type Bean struct {
   Name string
}
func NewBean() *Bean {
	return &Bean{}
}