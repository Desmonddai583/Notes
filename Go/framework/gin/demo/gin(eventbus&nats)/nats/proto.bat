protoc --proto_path=protos --go_out=./../   UserModel.proto

protoc --proto_path=protos   --go_out=plugins=grpc:services  ScoreService.proto
protoc --proto_path=protos   --go_out=plugins=grpc:services  UserService.proto