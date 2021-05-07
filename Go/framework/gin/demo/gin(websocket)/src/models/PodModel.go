package models

//type PodModels []*PodModel
//func(this *PodModels) ParseAction(action string ) error {
//
//}
type PodModel struct {
	PodName  string
	PodImage string
	PodNode  string
}

func (this *PodModel) ParseAction(action string) (*WsResponse, error) {
	//fmt.Println(action)
	//fmt.Println(this.PodName,this.PodImage)
	return NewWsResponse("PodModel", MockPodeList()), nil
}
func MockPodeList() []*PodModel {
	return []*PodModel{
		{PodName: "pod-101", PodImage: "nginx:1.18", PodNode: "node1"},
		{PodName: "pod-76xs", PodImage: "alpine:3.12", PodNode: "node2"},
		{PodName: "pod-F#ff3", PodImage: "tomcat:8", PodNode: "node3"},
	}
}
