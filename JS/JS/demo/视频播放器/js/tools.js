/**
 * 缓动动画
 * @param ele 需要操作的元素
 * @param obj 需要操作的属性
 * @param fn 动画执行完毕回调函数
 */
function easingAnimation(ele, obj, fn) {
    clearInterval(ele.timerId);
    // 1.开启定时器累加位置
    ele.timerId = setInterval(function () {
        var flag = true;
        for(var key in obj){
            // 1.获取元素开始的位置
            var begin = parseInt(getStyleAttr(ele, key)) || 0;
            if(key === "scrollTop"){
                begin = ele.scrollTop;
            }
            // 2.获取元素结束的位置
            var target = obj[key];
            // 3.计算元素每次移动的步长
            var step = (target - begin) * 0.3;
            step = begin < target ? Math.ceil(step) : Math.floor(step);
            // 4.让元素移动
            if(key === "scrollTop"){
                ele[key] = begin + step;
            }else{
                ele.style[key] = begin + step + "px";
            }
            // 5.判断有没有抵达终点
            if(Math.abs(target - begin) > Math.abs(step)){
                console.log(Math.abs(target - begin), Math.abs(step));
                flag = false;
            }else if(Math.abs(target - begin) <= Math.abs(step)){
                if(key === "scrollTop"){
                    ele[key] = target;
                }else{
                    ele.style[key] = target + "px";
                }
            }
        }
        if(flag){
            clearInterval(ele.timerId);
            if(fn instanceof Function){
                fn();
            }
        }

    }, 100);
}

/**
 * 匀速动画
 * @param ele 需要获取的元素
 * @param obj 动画属性对象
 * @returns fn 动画执行完毕之后回调
 */
function linearAnimation(ele, obj, fn) {
    clearInterval(ele.timerId);
    // 2.1开启定时器不断累加left的值
    ele.timerId = setInterval(function () {
        var flag = true;
        for(var key in obj){
            // 2.2获取元素开始的位置
            var begin = parseInt(getStyleAttr(ele, key)) || 0;
            // 2.3获取结束的位置
            var target = obj[key];
            // 2.4定义每次移动的步长
            var step = (begin < target) ? 10 : -10;
            // 2.5让元素动起来
            ele.style[key] = begin + step + "px";
            // 2.6添加结束条件
            if(Math.abs(target - begin) > Math.abs(step)){
                flag = false;
            }else if(Math.abs(target - begin) <= Math.abs(step)){
                ele.style[key] = target + "px";
            }
        }
        if(flag){
            clearInterval(ele.timerId);
            if(fn){
                fn();
            }
        }
    }, 10);
}

/**
 * 获取样式兼容性的处理
 * @param obj 需要获取的元素
 * @param attr 需要获取的属性
 * @returns {string} 获取到的值
 */
function getStyleAttr(obj, attr) {
    if(obj.currentStyle){
        return obj.currentStyle[attr];
    }else{
        return window.getComputedStyle(obj, null)[attr];
    }
}

/**
 * 获取浏览器可视区域的大小
 * @returns {{width: number, height: number}}
 */
function getScreen() {
    if(window.innerWidth){
        return {
            width: window.innerWidth,
            height: window.innerHeight
        }
    }else{
        return {
            width: document.documentElement.clientWidth,
            height: document.documentElement.clientHeight
        }
    }
}

/**
 * 获取网页滚动的偏移位
 * @returns {{top: number, left: number}}
 */
function getPageScroll() {
    var top = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
    var left = window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft;
    return {
        top: top,
        left: left
    }
}