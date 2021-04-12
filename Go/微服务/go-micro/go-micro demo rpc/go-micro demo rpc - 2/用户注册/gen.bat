cd Services/protos
#protoc --micro_out=../ --go_out=../ test.proto
#protoc-go-inject-tag -input=../test.pb.go

#protoc --go_out=plugins=grpc:../../ServiceGW test.proto
#protoc  --grpc-gateway_out=logtostderr=true:../../ServiceGW test.proto

protoc  --go_out=../ Models.proto
protoc --micro_out=../ --go_out=../ UserService.proto
protoc-go-inject-tag -input=../Models.pb.go
protoc-go-inject-tag -input=../UserService.pb.go
cd .. && cd ..
