package AppLib

import (
	"fmt"
	"reflect"
	"regexp"

	"gopkg.in/go-playground/validator.v9"
)

func AddRegexTag(tagName string, pattern string, v *validator.Validate) error {
	return v.RegisterValidation(tagName, func(fl validator.FieldLevel) bool {
		m, _ := regexp.MatchString(pattern, fl.Field().String())
		return m
	}, false)
}

func ValidErrMsg(obj interface{}, err error) error {
	getObj := reflect.TypeOf(obj)
	if err != nil {
		if errs, ok := err.(validator.ValidationErrors); ok {
			for _, e := range errs {
				fmt.Println(e.Field())
				if f, exist := getObj.Elem().FieldByName(e.Field()); exist {
					if value, ok := f.Tag.Lookup("vmsg"); ok {
						return fmt.Errorf("%s", value)
					} else {
						return fmt.Errorf("%s", e)
					}
				} else {
					return fmt.Errorf("%s", e)
				}
			}
		}
	}
	return nil
}
