// 题1:
console.log('script start');

setTimeout(function () {
    console.log('setTimeout');
}, 0);

Promise.resolve().then(function () {
    console.log('promise1');
}).then(function () {
    console.log('promise2');
});

console.log('script end')
    //  题2：
    <
    a id = "link"
href = "http://www.zhufengpeixun.cn" > link < /a> <
    script >
    let link = document.getElementById('link');
const nextTick = new Promise(resolve => {
    link.addEventListener('click', resolve);
});
nextTick.then(event => {
    event.preventDefault();
    console.log('event.preventDefault()');
});
//link.click(); 
<
/script>

// 题3:
async function async1() {
    console.log('async1 start')
    await async2()
    console.log('async1 end')
}
async function async2() {
    console.log('async2')
}
console.log('script start')
setTimeout(function () {
    console.log('setTimeout')
})
async1()
new Promise(function (resolve) {
    console.log('promise1')
    resolve()
}).then(function () {
    console.log('promise2')
})
console.log('script end')