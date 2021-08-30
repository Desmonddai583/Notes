protoc --proto_path=protos --go_out=pbfiles   prod_model.proto
protoc --proto_path=protos --go_out=plugins=grpc:pbfiles  prod_service.proto

protoc --proto_path=protos --grpc-gateway_out=logtostderr=true:pbfiles prod_service.proto
