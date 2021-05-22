package scripts

const Build_Script = `docker run --rm  \
-v /home/shenyi/myweb:/app \
-v /home/shenyi/gopath:/go \
-w /app/src \
-e GOPROXY=https://goproxy.cn \
golang:1.14.4-alpine3.12 \
go build -o ../myserver main.go
`
