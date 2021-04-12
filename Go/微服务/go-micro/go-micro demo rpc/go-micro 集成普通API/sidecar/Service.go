package sidecar

type Service struct {
	Name  string
	Nodes []*ServiceNode
}
type ServiceNode struct {
	Id      string //服务ID，不能重复
	Port    int
	Address string
}

func NewService(name string) *Service {
	return &Service{Name: name, Nodes: make([]*ServiceNode, 0)}
}
func NewServiceNode(id string, port int, address string) *ServiceNode {
	return &ServiceNode{Id: id, Port: port, Address: address}
}
func (this *Service) AddNode(id string, port int, address string) {
	this.Nodes = append(this.Nodes, NewServiceNode(id, port, address))
}
