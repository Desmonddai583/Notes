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
	Weight int //默认权重
	CWeight int //当前权重,平滑算法中使用
	FailWeight int //一旦失败后，降低的权重
	Status string //状态，默认UP ,宕机=DOWN
	FailCount int //失败计数器，默认是0
	SuccessCount int //成功计数器
}
func NewHttpServer(host string,weight int ) *HttpServer  {
	return &HttpServer{Host:host,Weight:weight,CWeight:0,Status:"UP" }  //注意这里，一开始CWeight是0
}
type LoadBalance struct { //负载均衡类
	 Servers HttpServers
	 CurIndex int  //指向当前访问的服务器index
	 DownCount int //Down的节点数
}
func NewLoadBalance() *LoadBalance {
   return &LoadBalance{Servers:make([]*HttpServer,0)}
}
func(this *LoadBalance) AddServer(server *HttpServer)  {
	 this.Servers=append(this.Servers,server)
}
func(this *LoadBalance) IsAllDown() bool  { //获取是否
	downcount:=0
	for _,s:=range this.Servers{
		if s.Status=="DOWN"{
			downcount++
		}
	}
	if downcount==len(this.Servers){
		return true
	}
	return false
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
//普通轮询算法,使用了计数器机制
func(this *LoadBalance) RoundRobin() *HttpServer  {
   server:=this.Servers[this.CurIndex]
   this.CurIndex=(this.CurIndex+1) % len(this.Servers)
   if server.Status=="DOWN" && !this.IsAllDown(){ //如果都Down掉了,直接继续轮询，不判断DOWN
   	return this.RoundRobin() //递归
   }
   return server
}
//数组式加权轮询算法,实际开发不建议使用
func(this *LoadBalance) RoundRobinByWeight() *HttpServer  { //加权轮询
	server:=this.Servers[ServerIndices[this.CurIndex]]
	this.CurIndex=(this.CurIndex+1) % len(ServerIndices)
	return server
}
//加权轮询改进算法，使用区间判断
func(this *LoadBalance) RoundRobinByWeight2() *HttpServer  {//加权轮询 ,使用区间算法
	server:=this.Servers[0]
	sum:=0
	//3:1:1
	for i:=0;i<len(this.Servers);i++{
		realWeight:=this.Servers[i].Weight-this.Servers[i].FailWeight //计算真实权重
		if realWeight==0 {
			continue  //如果权重是0 ，则跳过
		}
		//	sum+=this.Servers[i].Weight   //第一次是3   [0,3)  [3,4)   [4,5)
		sum+=realWeight
		if this.CurIndex<sum {
			server=this.Servers[i]
			if this.CurIndex==sum-1 && i!=len(this.Servers)-1{
				this.CurIndex++
			} else {
				this.CurIndex=(this.CurIndex+1)%sum//这里是重要的一步
			}
			break
		} else{ //上节课的一个BUG,这里当currentIndex>sum时要进行初始化
			this.CurIndex=0
		}
	}

	return server
}


//即时计算总权重
func(this *LoadBalance) getSumWeight() int  {
	sum:=0
	for _,server:=range this.Servers{
		realWeight:=server.Weight-server.FailWeight
		if realWeight>0{
			sum=sum+realWeight
		}
	}
	return sum
}

//平滑加权轮询
func(this *LoadBalance) RoundRobinByWeight3() *HttpServer {
  for _,s:=range this.Servers{
  	s.CWeight=s.CWeight+(s.Weight-s.FailWeight)
  }
  sort.Sort(this.Servers)
  max:=this.Servers[0] //返回最大 作为命中服务

  max.CWeight=max.CWeight-this.getSumWeight()

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
	LB.AddServer(NewHttpServer("http://localhost:9091",5)) //web1
	LB.AddServer(NewHttpServer("http://localhost:9092",2)) //web2
	LB.AddServer(NewHttpServer("http://localhost:9093",2)) //web2
	for index,server:=range LB.Servers{
		if server.Weight>0{
			for i:=0;i<server.Weight;i++{
				ServerIndices=append(ServerIndices,index)
			}
		}
		SumWeight=SumWeight+server.Weight  //计算加权总和
	}
	//fmt.Println(ServerIndices)
	go(func() {
		checkServers(LB.Servers) //这里直接传LoadBalance
	})()

}
func checkServers(servers HttpServers)  {
	t:= time.NewTicker(time.Second*3)
	check:=NewHttpChecker(servers)
	for {
		select{
		case <- t.C:
			check.Check(time.Second*2)
			for _,s:=range servers{
				//fmt.Println(s.Host,s.Status,s.FailCount,s.SuccessCount)
				fmt.Println(s.Host,s.Weight,s.FailWeight)
			}
			fmt.Println("---------------------------------")
		}
	}
}


