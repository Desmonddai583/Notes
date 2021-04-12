// Code generated by protoc-gen-go. DO NOT EDIT.
// source: ProdService.proto

package Services

import (
	fmt "fmt"
	proto "github.com/golang/protobuf/proto"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion3 // please upgrade the proto package

type ProdsRequest struct {
	Size                 int32    `protobuf:"varint,1,opt,name=size,proto3" json:"size,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *ProdsRequest) Reset()         { *m = ProdsRequest{} }
func (m *ProdsRequest) String() string { return proto.CompactTextString(m) }
func (*ProdsRequest) ProtoMessage()    {}
func (*ProdsRequest) Descriptor() ([]byte, []int) {
	return fileDescriptor_50db98fd6a3e2ab5, []int{0}
}

func (m *ProdsRequest) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_ProdsRequest.Unmarshal(m, b)
}
func (m *ProdsRequest) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_ProdsRequest.Marshal(b, m, deterministic)
}
func (m *ProdsRequest) XXX_Merge(src proto.Message) {
	xxx_messageInfo_ProdsRequest.Merge(m, src)
}
func (m *ProdsRequest) XXX_Size() int {
	return xxx_messageInfo_ProdsRequest.Size(m)
}
func (m *ProdsRequest) XXX_DiscardUnknown() {
	xxx_messageInfo_ProdsRequest.DiscardUnknown(m)
}

var xxx_messageInfo_ProdsRequest proto.InternalMessageInfo

func (m *ProdsRequest) GetSize() int32 {
	if m != nil {
		return m.Size
	}
	return 0
}

type ProdListResponse struct {
	Data                 []*ProdModel `protobuf:"bytes,1,rep,name=data,proto3" json:"data,omitempty"`
	XXX_NoUnkeyedLiteral struct{}     `json:"-"`
	XXX_unrecognized     []byte       `json:"-"`
	XXX_sizecache        int32        `json:"-"`
}

func (m *ProdListResponse) Reset()         { *m = ProdListResponse{} }
func (m *ProdListResponse) String() string { return proto.CompactTextString(m) }
func (*ProdListResponse) ProtoMessage()    {}
func (*ProdListResponse) Descriptor() ([]byte, []int) {
	return fileDescriptor_50db98fd6a3e2ab5, []int{1}
}

func (m *ProdListResponse) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_ProdListResponse.Unmarshal(m, b)
}
func (m *ProdListResponse) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_ProdListResponse.Marshal(b, m, deterministic)
}
func (m *ProdListResponse) XXX_Merge(src proto.Message) {
	xxx_messageInfo_ProdListResponse.Merge(m, src)
}
func (m *ProdListResponse) XXX_Size() int {
	return xxx_messageInfo_ProdListResponse.Size(m)
}
func (m *ProdListResponse) XXX_DiscardUnknown() {
	xxx_messageInfo_ProdListResponse.DiscardUnknown(m)
}

var xxx_messageInfo_ProdListResponse proto.InternalMessageInfo

func (m *ProdListResponse) GetData() []*ProdModel {
	if m != nil {
		return m.Data
	}
	return nil
}

func init() {
	proto.RegisterType((*ProdsRequest)(nil), "Services.ProdsRequest")
	proto.RegisterType((*ProdListResponse)(nil), "Services.ProdListResponse")
}

func init() { proto.RegisterFile("ProdService.proto", fileDescriptor_50db98fd6a3e2ab5) }

var fileDescriptor_50db98fd6a3e2ab5 = []byte{
	// 169 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0xe2, 0x12, 0x0c, 0x28, 0xca, 0x4f,
	0x09, 0x4e, 0x2d, 0x2a, 0xcb, 0x4c, 0x4e, 0xd5, 0x2b, 0x28, 0xca, 0x2f, 0xc9, 0x17, 0xe2, 0x80,
	0x72, 0x8b, 0xa5, 0x78, 0x7c, 0xf3, 0x53, 0x52, 0x73, 0x8a, 0x21, 0xe2, 0x4a, 0x4a, 0x5c, 0x3c,
	0x20, 0xc5, 0xc5, 0x41, 0xa9, 0x85, 0xa5, 0xa9, 0xc5, 0x25, 0x42, 0x42, 0x5c, 0x2c, 0xc5, 0x99,
	0x55, 0xa9, 0x12, 0x8c, 0x0a, 0x8c, 0x1a, 0xac, 0x41, 0x60, 0xb6, 0x92, 0x35, 0x97, 0x00, 0x48,
	0x8d, 0x4f, 0x66, 0x71, 0x49, 0x50, 0x6a, 0x71, 0x41, 0x7e, 0x5e, 0x71, 0xaa, 0x90, 0x3a, 0x17,
	0x4b, 0x4a, 0x62, 0x49, 0xa2, 0x04, 0xa3, 0x02, 0xb3, 0x06, 0xb7, 0x91, 0xb0, 0x1e, 0xcc, 0x78,
	0x3d, 0x90, 0x4a, 0xb0, 0x0d, 0x41, 0x60, 0x05, 0x46, 0x81, 0x5c, 0xdc, 0x48, 0xae, 0x11, 0x72,
	0xe2, 0xe2, 0x71, 0x4f, 0x2d, 0x01, 0x5b, 0x09, 0x32, 0x4f, 0x48, 0x0c, 0x55, 0x27, 0xcc, 0x1d,
	0x52, 0x52, 0xa8, 0xe2, 0xc8, 0x76, 0x27, 0xb1, 0x81, 0x9d, 0x6e, 0x0c, 0x08, 0x00, 0x00, 0xff,
	0xff, 0xd4, 0xc3, 0xc6, 0x09, 0xe7, 0x00, 0x00, 0x00,
}
