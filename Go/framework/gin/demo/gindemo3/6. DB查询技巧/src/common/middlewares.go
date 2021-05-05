package common

import (
	"bytes"
	"github.com/gin-gonic/gin"
	"runtime"
)
func PanicTrace(kb int) []byte {
	s := []byte("/src/runtime/panic.go")
	e := []byte("\ngoroutine ")
	line := []byte("\n")
	stack := make([]byte, kb<<10) //4KB
	length := runtime.Stack(stack, true)
	start := bytes.Index(stack, s)
	stack = stack[start:length]
	start = bytes.Index(stack, line) + 1
	stack = stack[start:]
	end := bytes.LastIndex(stack, line)
	if end != -1 {
		stack = stack[:end]
	}
	end = bytes.Index(stack, e)
	if end != -1 {
		stack = stack[:end]
	}
	stack = bytes.TrimRight(stack, "\n")
	return stack
}
func ErrorHandler() gin.HandlerFunc{
	return func(context *gin.Context) {
		defer func() {
			if e:=recover();e!=nil{
				//log.Println(string(PanicTrace(20)))
				context.JSON(400,gin.H{"message":e})
			}
		}()
		context.Next()
	}
}