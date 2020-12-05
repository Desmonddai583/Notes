package main
type HttpStatus struct {
	Code int
	Message string
}

func NewHttpStatus(code int ,message string) HttpStatus  {
	hs:=HttpStatus{code,message}
	return hs
}