set GOOS=linux
set GOARCH=amd64
go build -o prodservice server.go
go build -o prodAdapter mesh/prodsConsumer.go