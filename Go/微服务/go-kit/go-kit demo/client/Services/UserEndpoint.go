package Services

import (
	"context"
	"fmt"
	"strconv"

	"github.com/go-kit/kit/endpoint"
	"service.jtthink.com/util"
)

type UserRequest struct {
	Uid    int `json:"uid"`
	Method string
}
type UserResponse struct {
	Result string `json:"result"`
}

func GenUserEndpoint(userService IUserService) endpoint.Endpoint {
	return func(ctx context.Context, request interface{}) (response interface{}, err error) {
		r := request.(UserRequest)
		result := "nothing"
		if r.Method == "GET" {
			result = userService.GetName(r.Uid) + strconv.Itoa(util.ServicePort)
		} else if r.Method == "DELETE" { //代表删除
			err := userService.DelUser(r.Uid)
			if err != nil { //代表有错，无法删除
				result = err.Error()
			} else {
				result = fmt.Sprintf("userid为%d的用户删除成功", r.Uid)
			}
		}

		return UserResponse{Result: result}, nil
	}
}
