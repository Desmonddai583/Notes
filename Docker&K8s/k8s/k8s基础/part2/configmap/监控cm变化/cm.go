package main

import (
	"k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/util/wait"
	"k8s.io/client-go/informers"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"log"
)
//var api_server string
//var token string
//func init() {
//	api_server=fmt.Sprintf("https://%s:%s",
//		os.Getenv("KUBERNETES_SERVICE_HOST"),os.Getenv("KUBERNETES_PORT_443_TCP_PORT"))
//    f,err:=os.Open("/var/run/secrets/kubernetes.io/serviceaccount/token")
//    if err!=nil{
//    	log.Fatal(err)
//	 }
//    b,_:=ioutil.ReadAll(f)
//    token=string(b)
//}
func getClient() *kubernetes.Clientset{
	config:=&rest.Config{
		Host:"http://124.70.204.12:8009",
		//Host:api_server,
		//BearerToken:token,
		//TLSClientConfig:rest.TLSClientConfig{CAFile:"/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"},
 	}
	c,err:=kubernetes.NewForConfig(config)
	if err!=nil{
		log.Fatal(err)
	}

	return c
}
type CmHandler struct{}
func(this *CmHandler) OnAdd(obj interface{}){}
func(this *CmHandler) OnUpdate(oldObj, newObj interface{}){
     if newObj.(*v1.ConfigMap).Name=="mycm"{
     	log.Println("mycm发生了变化")
	 }
}
func(this *CmHandler)	OnDelete(obj interface{}){}

func main() {
       //cm,err:=getClient().CoreV1().ConfigMaps("default").
       //	Get(context.Background(),"mycm",v1.GetOptions{})
       //if err!=nil{
       //	log.Fatal(err)
	   //}
       //for k,v:=range cm.Data{
       //	   fmt.Printf("key=%s,value=%s\n",k,v)
	   //}

	fact:=informers.NewSharedInformerFactory(getClient(), 0)

	cmInformer:=fact.Core().V1().ConfigMaps()
	cmInformer.Informer().AddEventHandler(&CmHandler{})

	fact.Start(wait.NeverStop)
	select {}

}