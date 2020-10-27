let test = function(){
console.log('callback');
}
let timer = setInterval(test,1000);
timer.unref();
setTimeout(function(){
    timer.ref();
},3000)