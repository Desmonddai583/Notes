// generator 生成器 可以生成 迭代器

// generator也是一个函数，和普通函数不一样，可以有暂停的功能

// 迭代器就是有next方法的，没次调用后都会返回一个done和一个叫value的属性
function read(arrs){
    let index = 0; //默认先迭代第一项
    let len = arrs.length;
    return {
        next(){
            return {value:arrs[index],done:index++===len?true:false}
        }
    }
}
let it = read(['react','vue','angular']);
let flag = true
do{
   let {done,value} =  it.next();
   flag = done;
   console.log(value);
}while(!flag)
// it.next(); // {done:false,value:'react'}
// it.next(); // {done:false,value:'vue'}
// it.next(); // {done:false,value:'angular'}
// it.next(); // {done:true,value:undefined}

function* read(arrs){ //genrator函数可以配yield 产出
        yield arrs[0];
        yield arrs[1]; 
        yield arrs[2]; 
}
let it = read(['react','vue','angular']);
do{
    let {done,value} =  it.next();
    flag = done;
    console.log(value);
 }while(!flag);