package main

import (
	"fmt"
	"goplus/src/pipeline/getdata"
	"goplus/src/pipeline/v1"
	"goplus/src/pipeline/v2"
	"time"
)
func test(v string)  {
	nums:=[]int{3,4,5,6,7,8,10,11,12,13,14}
	start:=time.Now().Unix()
	if v=="v1"{
		v1.Test(nums)
	}else{
		v2.Test(nums)
	}
	end:=time.Now().Unix()
	fmt.Printf("%s测试--用时:%d秒\r\n",v,end-start)
}

func testData()  {
	start:=time.Now().UnixNano() / 1e6
	getdata.PipeTest()
	end:=time.Now().UnixNano() / 1e6
	fmt.Printf("测试--用时:%d毫秒\r\n",end-start)
}

func main()  {
	testData()

}