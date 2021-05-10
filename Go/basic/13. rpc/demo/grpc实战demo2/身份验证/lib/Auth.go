package lib

import "context"

type Auth struct {
	Token string

}
func NewAuth(token string) *Auth {
	return &Auth{Token: token}
}
func(this *Auth) GetRequestMetadata(ctx context.Context, uri ...string) (map[string]string, error){
	return map[string]string{
		"token":this.Token,
	},nil
}

func(this *Auth) RequireTransportSecurity() bool{
	return true
}
