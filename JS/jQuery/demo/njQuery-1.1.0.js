(function( window, undefined ) {
    var njQuery = function(selector) {
        return new njQuery.prototype.init(selector);
    }
    njQuery.prototype = {
        constructor: njQuery,
        init: function (selector) {
            // 0.去除字符串两端的空格
            selector = njQuery.trim(selector);
            // 1.传入 '' null undefined NaN  0  false, 返回空的jQuery对象
            if(!selector){
                return this;
            }
            // 2.方法处理
            else if(njQuery.isFunction(selector)){
                njQuery.ready(selector);
            }
            // 3.字符串
            else if(njQuery.isString(selector)){
                // 2.1判断是否是代码片段 <a>
                if(njQuery.isHTML(selector)){
                    // 1.根据代码片段创建所有的元素
                    var temp = document.createElement("div");
                    temp.innerHTML = selector;
                    // 2.将创建好的一级元素添加到jQuery当中
                    [].push.apply(this, temp.children);
                }
                // 2.2判断是否是选择器
                else{
                    // 1.根据传入的选择器找到对应的元素
                    var res = document.querySelectorAll(selector);
                    // 2.将找到的元素添加到njQuery上
                    [].push.apply(this, res);
                }
            }
            // 4.数组
            else if(njQuery.isArray(selector)){
                // 转换为真数组
                var arr = [].slice.call(selector);
                // 将真数组数据添加到njQuery上
                [].push.apply(this, arr);
            }
            // 5.除上述类型以外
            else{
                this[0] = selector;
                this.length = 1;
            }
            // 返回njQuery
            return this;
        },
        jquery: "1.1.0",
        selector: "",
        length: 0,
        // [].push找到数组的push方法
        // 冒号前面的push将来由njQuery对象调用
        // 相当于 [].push.apply(this);
        push: [].push,
        sort: [].sort,
        splice: [].splice,
        toArray: function () {
            return [].slice.call(this);
        },
        get: function (num) {
            // 没有传递参数
            if(arguments.length === 0){
                return this.toArray();
            }
            // 传递不是负数
            else if(num >= 0){
                return this[num];
            }
            // 传递负数
            else{
                return this[this.length + num];
            }
        },
        eq: function (num) {
            // 没有传递参数
            if(arguments.length === 0){
                return new njQuery();
            }else{
                return njQuery(this.get(num));
            }
        },
        first: function () {
            return this.eq(0);
        },
        last: function () {
            return this.eq(-1);
        },
        each: function (fn) {
            return njQuery.each(this, fn);
        }
    }
    njQuery.extend = njQuery.prototype.extend = function (obj) {
        for(var key in obj){
            this[key] = obj[key];
        }
    }
    njQuery.extend({
        isString : function(str){
            return typeof str === "string"
        },
        isHTML : function(str){
            return str.charAt(0) === "<" &&
                str.charAt(str.length - 1) === ">" &&
                str.length >= 3;
        },
        trim : function(str){
            if(!njQuery.isString(str)){
                return str;
            }
            // 判断是否支持trim方法
            if(str.trim){
                return str.trim();
            }else{
                return str.replace(/^\s+|\s+$/g, "");
            }
        },
        isObject : function(sele){
            return typeof sele === "object"
        },
        isWindow : function(sele){
            return sele === window;
        },
        isArray : function(sele){
            if(njQuery.isObject(sele) &&
                !njQuery.isWindow(sele) &&
                "length" in sele){
                return true;
            }
            return false;
        },
        isFunction : function(sele){
            return typeof sele === "function";
        },
        ready: function (fn) {
            // 如果已经加载过了, 那么直接调用回调
            if(document.readyState == "complete"){
                fn();
            }
            // 如果没有加载过,判断是否支持addEventListener方法, 支持就使用addEventListener方法监听DOM加载
            else if(document.addEventListener){
                document.addEventListener("DOMContentLoaded", function () {
                    fn();
                });
            }
            // 如果不支持addEventListener方法, 就使用attachEvent方法监听
            else{
                document.attachEvent("onreadystatechange", function () {
                    if(document.readyState == "complete"){
                       fn();
                    }
                });
            }
        },
        each: function (obj, fn) {
            // 1.判断是否是数组
            if(njQuery.isArray(obj)){
                for(var i = 0; i < obj.length; i++){
                   // var res = fn(i, obj[i]);
                   var res = fn.call(obj[i], i, obj[i]);
                   if(res === true){
                       continue;
                   }else if(res === false){
                       break;
                   }
                }
            }
            // 2.判断是否是对象
            else if(njQuery.isObject(obj)){
                for(var key in obj){
                    // var res = fn(key, obj[key]);
                    var res = fn.call(obj[key], key, obj[key]);
                    if(res === true){
                        continue;
                    }else if(res === false){
                        break;
                    }
                }
            }
            return obj;
        },
        map: function (obj, fn) {
            var res = [];
            // 1.判断是否是数组
            if(njQuery.isArray(obj)){
                for(var i = 0; i < obj.length; i++){
                    var temp = fn(obj[i], i);
                    if(temp){
                        res.push(temp);
                    }
                }
            }
            // 2.判断是否是对象
            else if(njQuery.isObject(obj)){
                for(var key in obj){
                    var temp =fn(obj[key], key);
                    if(temp){
                        res.push(temp);
                    }
                }
            }
            return res;
        }
    });
    njQuery.prototype.init.prototype = njQuery.prototype;
    window.njQuery = window.$ = njQuery;
})( window );