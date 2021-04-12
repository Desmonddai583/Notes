cd Services/protos
protoc --micro_out=../ --go_out=../ test.proto
protoc-go-inject-tag -input=../test.pb.go
cd .. && cd ..
