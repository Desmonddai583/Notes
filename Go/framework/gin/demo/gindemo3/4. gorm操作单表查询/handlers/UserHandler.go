package handlers

import (
	"ginskill/src/data/Getter"
	"ginskill/src/result"
	"github.com/gin-gonic/gin"
)
//gin handlerfunc
func UserList(c *gin.Context) {
	//// {message:"xxx",code:"100001",result:xxx}
	R(c)("userlist",
		    "100001",
				   Getter.UserGetter.GetUserList())(OK)
}
func UserDetail(c *gin.Context){
	var id=&struct {Id int `uri:"id" binding:"required,gt=3"`}{}
	result.Result(c.ShouldBindUri(id)).Unwrap()

	R(c)("userlist",
		"100001",
		Getter.UserGetter.GetUserByID(id.Id).Unwrap())(OK)
}