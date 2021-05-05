package handlers

import (
	"ginskill/src/data/Getter"
	"ginskill/src/models/UserModel"
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
		id:=&struct {Id int `uri:"id" binding:"required,gt=1"`}{}
		result.Result(c.ShouldBindUri(id)).Unwrap()

		R(c)("userdetail",
			"100005", Getter.UserGetter.GetUserByID(id.Id).Unwrap())(OK)
}
func UserSave(c *gin.Context){
	u:=UserModel.New()
	result.Result(c.ShouldBindJSON(u)).Unwrap()
	R(c)("saveuser",
		"10006", "true")(OK)
}


