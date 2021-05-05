package validators

import (
	"fmt"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	"log"
)

var myvalid *validator.Validate
var validatorError map[string]string
func init() {
	validatorError=make(map[string]string)
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		myvalid=v
	}else{
		log.Fatal("error validator")
	}
}
func registerValidation(tag string, fn validator.Func){
	err:=myvalid.RegisterValidation(tag,fn)
	if err!=nil{
		log.Fatal(fmt.Sprintf("validator %s error",tag))
	}
}
func CheckErrors(errors error){
    if errs,ok:=errors.(validator.ValidationErrors);ok{
    	for _,err:=range errs{
			if v,exists:=validatorError[err.Tag()];exists{
				panic(v)
			}
		}
	}
}
