package utils

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strings"
)

type OAuthUser struct {
	UserId string `json:"user_id"`
	Expire int64  `json:"expire"`
}

func GetUserInfo(url string, token string, isbearer bool) *OAuthUser {
	var req *http.Request
	var err error
	if isbearer {
		req, err = http.NewRequest("POST", url, nil)
		if err != nil {
			panic(err.Error())
		}
		req.Header.Set("Authorization", "Bearer "+token)
	} else {
		req, err = http.NewRequest("POST", url, strings.NewReader("access_token="+token))
		req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		if err != nil {
			panic(err.Error())
		}

	}
	rsp, err := http.DefaultClient.Do(req)
	if err != nil {
		panic(err.Error())
	}
	defer rsp.Body.Close()
	b, _ := ioutil.ReadAll(rsp.Body)
	oauthUser := &OAuthUser{}
	err = json.Unmarshal(b, oauthUser)
	if err != nil {
		panic(err.Error())
	}
	return oauthUser
}
