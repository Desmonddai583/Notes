package code

import (
	"github.com/gin-gonic/gin"
)

type MyHandler func(c *gin.Context) (string, int, interface{})

func Handler() func(h MyHandler) gin.HandlerFunc {
	return func(h MyHandler) gin.HandlerFunc {
		return func(context *gin.Context) {
			msg, code, result := h(context)
			if code > 200 {
				context.JSON(200, gin.H{"message": msg, "code": code, "result": result})
			} else {
				context.JSON(400, gin.H{"message": msg, "code": code, "result": result})
			}

		}
	}
}

func GetUserList(c *gin.Context) (string, int, interface{}) {
	//各种业务代码

	return "userlist", 10001, "userlist"
}
func GetUserDetail(c *gin.Context) (string, int, interface{}) {
	//各种业务代码
	return "userdetail", 10002, "userdetail:" + c.Param("id")
}
