package Services

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"

	mymux "github.com/gorilla/mux"
	"service.jtthink.com/util"
)

func DecodeUserRequest(c context.Context, r *http.Request) (interface{}, error) {
	vars := mymux.Vars(r)

	if uid, ok := vars["uid"]; ok {
		uid, _ := strconv.Atoi(uid)
		return UserRequest{
			Uid:    uid,
			Method: r.Method,
			Token:  r.URL.Query().Get("token"),
		}, nil
	}
	return nil, errors.New("参数错误")

}
func EncodeUserResponse(ctx context.Context, w http.ResponseWriter, response interface{}) error {
	w.Header().Set("Content-type", "application/json")
	if response == nil {
		fmt.Println("aaa")
	}
	return json.NewEncoder(w).Encode(response)
}
func MyErrorEncoder(_ context.Context, err error, w http.ResponseWriter) {
	contentType, body := "text/plain; charset=utf-8", []byte(err.Error())
	w.Header().Set("content-type", contentType)
	if myerr, ok := err.(*util.MyError); ok {
		w.WriteHeader(myerr.Code)
		w.Write(body)
	} else {
		w.WriteHeader(500)
		w.Write(body)
	}

}
