cd Services/protos
protoc  --micro_out=../ --go_out=../ Models.proto
protoc  --micro_out=../ --go_out=../ ProdService.proto
protoc-go-inject-tag -input=../Models.pb.go
cd .. && cd ..
