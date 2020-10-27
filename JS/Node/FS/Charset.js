// 一般情况下能打印出来的都是10进制

console.log(0b11); // 二进制
console.log(0o17); // 15   
console.log(15);
console.log(0x1f); // 31  0-9 a b c d e f
// 一个字节有多少个位  1b = 8bit

// 一个字节最大是多少 最大255

console.log(parseInt('11111111',2)); // 转化程10进制
console.log((300).toString(16)); // 转化2进制
console.log(0xff);


// unicode 编码中文几个字符串  2字符串
//1110xxxx 10xxxxxx 10xxxxxx utf8三个 而且为了标准是utf8格式的

// 把unicode进制转化成utf8怎么转？

// 73E0 代表的是珠字 -> 转化成utf8编码

console.log(0x73E0.toString(2));//111
// 11100111 10001111 10100000 UTF8表示的二进制
// 16进制的表示
console.log(0b11100111.toString(16)); // e7 8f a0
console.log(0b10001111.toString(16))
console.log(0b10100000.toString(16))

function transfer(code){
    let arrs = ['1110','10','10']
    let c = code.toString(2);
    arrs[2] = arrs[2]+c.slice(c.length-6);
    arrs[1] = arrs[1]+c.slice(c.length-12,c.length-6);
    console.log(c.slice(0,c.length-12).padStart(0,4))
    arrs[0] =arrs[0]+c.slice(0,c.length-12).padStart(4,0);
    console.log(arrs)
    arrs = arrs.map(item=>parseInt(item,2).toString(16))
    console.log(arrs)
}
transfer(0x59DC); // 用来转化utf8的 
