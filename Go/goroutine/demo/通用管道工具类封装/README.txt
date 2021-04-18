管道模式
  假设有一个切片
    list:=[]int{2,3,6,12,22,16,4,9,23,64,62}
  两步需求:
    1、从里面找到偶数    
    2、把偶数乘以10

  最初级的封装
    func p(args []int,c1 Cmd,c2 Cmd) []int {
      ret:= c1(args)
      return c2(ret)
    }

管道模式之多路复用
  多个函数同时从同一个channel里读取数据。直至channel被关闭，则可以更好的利用多核
  
  基本代码
    func Pipe2(args []int ,c1 Cmd,cs ...PipeCmd) chan int{
      ret:=c1(args)
      out:=make(chan int)
      wg:=sync.WaitGroup{}
      for _,c:=range cs{
        getChan:=c(ret)
        wg.Add(1)
        go func(c chan int ) {
          defer wg.Done()
          for v:=range c{
            out<-v
          }
        }(getChan)
      }
      go func() {
        defer close(out)
        wg.Wait()
      }()
      return out
    }

场景演练：从mysql导出到csv
  装orm
    go get github.com/jinzhu/gorm
  
  下载数据
    http://www.jtthink.com/download/detail?did=234    

  需求
    把book表全部取出出来
    1、导入到文本文件中
    2、每1000条 一个文件

  建立一个数据对象
    type Book struct {
      BookId int `gorm:"column:book_id"`
      BookName string `gorm:"column:book_name"`
    }
    type BookList struct {
      Data []*Book
      Page int
    }

  读取数据库的方法
    const sql="select book_id,book_name from books order by book_id  limit ? offset ?"
    func ReadData(){
      page:=1
      pagesize:=1000
      for {
        booklist:=&BookList{make([]*Book,0),page}
        db:=AppInit.GetDB().Table("books").Raw(sql,pagesize,(page-1)*pagesize).Find(&booklist.Data)
        if db.Error!=nil || db.RowsAffected==0{
          break
        }
        err:=SaveData(booklist)
        if err!=nil{
          log.Println(err)
        }
        page++
      }
    }

  写CSV文件
    func SaveData(data *BookList) error   {
      file:=fmt.Sprintf("./src/pipeline/csv/%d.csv",data.Page)
      csvFile,err:= os.OpenFile(file,os.O_RDWR|os.O_CREATE|os.O_TRUNC,0666)
      if err!=nil{
        return err
      }
      defer csvFile.Close()
      w := csv.NewWriter(csvFile)//创建一个新的写入文件流
      header := []string{"book_id", "book_name"}
      export := [][]string{
        header,
      }
      for _,d:=range data.Data{
        cnt:=[]string{
          strconv.Itoa(d.BookId),
          d.BookName,
        }
        export=append(export,cnt)
      }
      err=w.WriteAll(export)
      if err!=nil{
        return err
      }
      w.Flush()
      return nil
    }

  管道模式改造
    管道
      1、入参(也就是管道连接点)
        type InChan chan *BookList
      2、结果集
        type Result struct{
          Page int
          Err error
        }
      3、管道数据输出
        type OutChan chan *Result

    定义管道命令类型
      type DataCmd func() InChan
      type DataPipeCmd  func(in InChan) OutChan
    
    管道函数
      func Pipe(c1 func() InChan,cs ...DataPipeCmd) OutChan{
        in:=c1()
        out:=make(OutChan)
        wg:=sync.WaitGroup{}
        for _,c:=range cs{
          getChan:=c(in)
          wg.Add(1)
          go func(input OutChan) {
            defer wg.Done()
            for v:=range input{
              out<-v
            }
          }(getChan)
        }
        go func() {
          defer close(out)
          wg.Wait()
        }()
        return out
      }

    执行函数
      func WriteData(in InChan) OutChan{
        out:=make(OutChan )
        go func() {
          defer close(out)
          for d:=range in {
            err:=SaveData(d)
            out<-&Result{Page:d.Page,Err:err}
          }
        }()
        return out
      }