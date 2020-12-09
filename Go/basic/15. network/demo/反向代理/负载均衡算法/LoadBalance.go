package util

import (
	"fmt"
	"hash/crc32"
	"math/rand"
	"sort"
	"time"
)

type HttpServers  []*HttpServer
func (p HttpServers) Len() int           { return len(p) }
func (p HttpServers) Less(i, j int) bool { return p[i].CWeight > p[j].CWeight } //从大到小排序
func (p HttpServers) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

type HttpServer struct {  //目标server类
	Host string
	Weight int
	CWeight int //当前权重
}
func NewHttpServer(host string,weight int ) *HttpServer  {
	return &HttpServer{Host:host,Weight:weight,CWeight:0 }  //注意这里，一开始CWeight是0
}
type LoadBalance struct { //负载均衡类
	 Servers HttpServers
	 CurIndex int  //指向当前访问的服务器index
}
func NewLoadBalance() *LoadBalance {
   return &LoadBalance{Servers:make([]*HttpServer,0)}
}
func(this *LoadBalance) AddServer(server *HttpServer)  {
	 this.Servers=append(this.Servers,server)
}
func(this *LoadBalance) SelectByRand() *HttpServer { //随机算法
	rand.Seed(time.Now().UnixNano())
	index:=rand.Intn(len(this.Servers))
	return this.Servers[index]
}
func(this *LoadBalance) SelectByIPHash(ip string) *HttpServer { //ip_hash算法
	index:=int(crc32.ChecksumIEEE([]byte(ip))) % len(this.Servers)
	return this.Servers[index]
}
func(this *LoadBalance) SelectByWeightRand() *HttpServer { //加权随机算法
	rand.Seed(time.Now().UnixNano())
	index:=rand.Intn(len(ServerIndices))
	return this.Servers[ServerIndices[index]]
}
func(this *LoadBalance) SelectByWeightRand2() *HttpServer { //加权随机算法(改良算法)
	rand.Seed(time.Now().UnixNano())
	sumList:=make([]int,len(this.Servers))
	sum:=0
	for i:=0;i<len(this.Servers);i++{
		sum+=this.Servers[i].Weight
		sumList[i]=sum
	}
	rad:=rand.Intn(sum) //[)
	for index,value:=range sumList{
		if rad<value{
			return this.Servers[index]
		}
	}
	return  this.Servers[0]
}
func(this *LoadBalance) RoundRobin() *HttpServer  {//轮询算法
   server:=this.Servers[this.CurIndex]
   this.CurIndex=(this.CurIndex+1) % len(this.Servers)
   return server
}

func(this *LoadBalance) RoundRobinByWeight() *HttpServer  { //加权轮询
	server:=this.Servers[ServerIndices[this.CurIndex]]
	this.CurIndex=(this.CurIndex+1) % len(ServerIndices)
	return server
}
func(this *LoadBalance) RoundRobinByWeight2() *HttpServer  {//加权轮询 ,使用区间算法
	server:=this.Servers[0]
	sum:=0
	//3:1:1
	for i:=0;i<len(this.Servers);i++{
		sum+=this.Servers[i].Weight   //第一次是3   [0,3)  [3,4)   [4,5)
		if this.CurIndex<sum {
			server=this.Servers[i]
			if this.CurIndex==sum-1 && i!=len(this.Servers)-1{
				this.CurIndex++
			} else {
				this.CurIndex=(this.CurIndex+1)%sum//这里是重要的一步
			}
			fmt.Println(this.CurIndex)
			break
		}
	}
	return server
}

//平滑加权轮询
func(this *LoadBalance) RoundRobinByWeight3() *HttpServer {
  for _,s:=range this.Servers{
  	s.CWeight=s.CWeight+s.Weight
  }
  sort.Sort(this.Servers)
  max:=this.Servers[0] //返回最大 作为命中服务

  max.CWeight=max.CWeight-SumWeight

	test:=""
	for _,s:=range this.Servers{
		test+=fmt.Sprintf("%d,",s.CWeight)
	}
	fmt.Println(test)

	return max
}


var LB *LoadBalance
var ServerIndices []int
var SumWeight int
func init()  {
	LB=NewLoadBalance()
	LB.AddServer(NewHttpServer("http://localhost:9091",3)) //web1
	LB.AddServer(NewHttpServer("http://localhost:9092",1)) //web2
	LB.AddServer(NewHttpServer("http://localhost:9093",1)) //web2
	for index,server:=range LB.Servers{
		if server.Weight>0{
			for i:=0;i<server.Weight;i++{
				ServerIndices=append(ServerIndices,index)
			}
		}
		SumWeight=SumWeight+server.Weight  //计算加权总和
	}
	//fmt.Println(ServerIndices)



}

