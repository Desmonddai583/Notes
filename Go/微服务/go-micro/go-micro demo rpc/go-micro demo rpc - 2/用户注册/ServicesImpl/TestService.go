package ServicesImpl

import (
	"context"
	"strconv"

	"tools.jtthink.com/Services"
)

type TestService struct {
}

func (this *TestService) Call(ctx context.Context, req *Services.TestRequest, rsp *Services.TestResponse) error {
	rsp.Data = "test" + strconv.Itoa(int(req.Id))
	return nil
}
