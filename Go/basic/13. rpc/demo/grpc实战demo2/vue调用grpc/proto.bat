protoc315   --proto_path=protos --plugin=protoc-gen-go=E:\video\2021-2\grpcpath\gopath\bin\protoc-gen-go.exe --go_out=./../   models.proto

protoc315   --proto_path=protos --plugin=protoc-gen-go=E:\video\2021-2\grpcpath\gopath\bin\protoc-gen-go.exe   --go-grpc_out=./../   service.proto

protoc315   --proto_path=protos  --include_imports --include_source_info --descriptor_set_out=prod.pb  service.proto


protoc315 --proto_path=protos models.proto --js_out=import_style=commonjs:htmls --grpc-web_out=import_style=commonjs,mode=grpcwebtext:htmls
protoc315 --proto_path=protos service.proto --js_out=import_style=commonjs:htmls --grpc-web_out=import_style=commonjs,mode=grpcwebtext:htmls