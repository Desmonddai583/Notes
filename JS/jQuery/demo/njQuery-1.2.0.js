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
    // 工具方法
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
        },
        // 来源: http://www.w3school.com.cn/xmldom/prop_node_nextsibling.asp
        get_nextsibling: function (n) {
            var x = n.nextSibling;
            while (x != null && x.nodeType!=1)
            {
                x=x.nextSibling;
            }
            return x;
        },
        get_previoussibling: function (n) {
            var x=n.previousSibling;
            while (x != null && x.nodeType!=1)
            {
                x=x.previousSibling;
            }
            return x;
        }
    });
    // DOM操作相关方法
    njQuery.prototype.extend({
        empty: function () {
            // 1.遍历指定的元素
            this.each(function (key, value) {
                value.innerHTML = "";
            });
            // 2.方便链式编程
            return this;
        },
        remove: function (sele) {
            if(arguments.length === 0){
                // 1.遍历指定的元素
                this.each(function (key, value) {
                    // 根据遍历到的元素找到对应的父元素
                    var parent = value.parentNode;
                    // 通过父元素删除指定的元素
                    parent.removeChild(value);
                });
            }else{
                var $this = this;
                // 1.根据传入的选择器找到对应的元素
                $(sele).each(function (key, value) {
                    // 2.遍历找到的元素, 获取对应的类型
                    var type = value.tagName;
                    // 3.遍历指定的元素
                    $this.each(function (k, v) {
                        // 4.获取指定元素的类型
                        var t = v.tagName;
                        // 5.判断找到元素的类型和指定元素的类型
                        if(t === type){
                            // 根据遍历到的元素找到对应的父元素
                            var parent = value.parentNode;
                            // 通过父元素删除指定的元素
                            parent.removeChild(value);
                        }
                    });
                })
            }
            return this;
        },
        html: function (content) {
            if(arguments.length === 0){
                return this[0].innerHTML;
            }else{
                this.each(function (key, value) {
                    value.innerHTML = content;
                })
            }
        },
        text: function (content) {
            if(arguments.length === 0){
                var res = "";
                this.each(function (key, value) {
                    res += value.innerText;
                });
                return res;
            }else{
                this.each(function (key, value) {
                    value.innerText = content;
                });
            }
        },
        appendTo: function (sele) {
            // 1.统一的将传入的数据转换为jQuery对象
            var $target = $(sele);
            var $this = this;
            var res = [];
            // 2.遍历取出所有指定的元素
            $.each($target, function (key, value) {
                // 2.遍历取出所有的元素
                $this.each(function (k, v) {
                    // 3.判断当前是否是第0个指定的元素
                    if(key === 0){
                        // 直接添加
                        value.appendChild(v);
                        res.push(v);
                    }else{
                        // 先拷贝再添加
                        var temp = v.cloneNode(true);
                        value.appendChild(temp);
                        res.push(temp);
                    }
                });
            });
            // 3.返回所有添加的元素
            return $(res);
        },
        prependTo: function (sele) {
            // 1.统一的将传入的数据转换为jQuery对象
            var $target = $(sele);
            var $this = this;
            var res = [];
            // 2.遍历取出所有指定的元素
            $.each($target, function (key, value) {
                // 2.遍历取出所有的元素
                $this.each(function (k, v) {
                    // 3.判断当前是否是第0个指定的元素
                    if(key === 0){
                        // 直接添加
                        value.insertBefore(v, value.firstChild);
                        res.push(v);
                    }else{
                        // 先拷贝再添加
                        var temp = v.cloneNode(true);
                        value.insertBefore(temp, value.firstChild);
                        res.push(temp);
                    }
                });
            });
            // 3.返回所有添加的元素
            return $(res);
        },
        append: function (sele) {
            // 判断传入的参数是否是字符串
            if(njQuery.isString(sele)){
                this[0].innerHTML += sele;
            }else{
                $(sele).appendTo(this);
            }
            return this;
        },
        prepend: function (sele) {
            // 判断传入的参数是否是字符串
            if(njQuery.isString(sele)){
                this[0].innerHTML = sele + this[0].innerHTML;
            }else{
                $(sele).prependTo(this);
            }
            return this;
        },
        insertBefore: function (sele) {
            // 1.统一的将传入的数据转换为jQuery对象
            var $target = $(sele);
            var $this = this;
            var res = [];
            // 2.遍历取出所有指定的元素
            $.each($target, function (key, value) {
                var parent = value.parentNode;
                // 2.遍历取出所有的元素
                $this.each(function (k, v) {
                    // 3.判断当前是否是第0个指定的元素
                    if(key === 0){
                        // 直接添加
                        parent.insertBefore(v, value);
                        res.push(v);
                    }else{
                        // 先拷贝再添加
                        var temp = v.cloneNode(true);
                        parent.insertBefore(temp, value);
                        res.push(temp);
                    }
                });
            });
            // 3.返回所有添加的元素
            return $(res);
        },
        insertAfter: function (sele) {
            // 1.统一的将传入的数据转换为jQuery对象
            var $target = $(sele);
            var $this = this;
            var res = [];
            // 2.遍历取出所有指定的元素
            $.each($target, function (key, value) {
                var parent = value.parentNode;
                var nextNode = $.get_nextsibling(value);
                // 2.遍历取出所有的元素
                $this.each(function (k, v) {
                    // 3.判断当前是否是第0个指定的元素
                    if(key === 0){
                        // 直接添加
                        parent.insertBefore(v, nextNode);
                        res.push(v);
                    }else{
                        // 先拷贝再添加
                        var temp = v.cloneNode(true);
                        parent.insertBefore(temp, nextNode);
                        res.push(temp);
                    }
                });
            });
            // 3.返回所有添加的元素
            return $(res);
        },
        replaceAll: function (sele) {
            // 1.统一的将传入的数据转换为jQuery对象
            var $target = $(sele);
            var $this = this;
            var res = [];
            // 2.遍历取出所有指定的元素
            $.each($target, function (key, value) {
                var parent = value.parentNode;
                // 2.遍历取出所有的元素
                $this.each(function (k, v) {
                    // 3.判断当前是否是第0个指定的元素
                    if(key === 0){
                        // 1.将元素插入到指定元素的前面
                        $(v).insertBefore(value);
                        // 2.将指定元素删除
                        $(value).remove();
                        res.push(v);
                    }else{
                        // 先拷贝再添加
                        var temp = v.cloneNode(true);
                        // 1.将元素插入到指定元素的前面
                        $(temp).insertBefore(value);
                        // 2.将指定元素删除
                        $(value).remove();
                        res.push(temp);
                    }
                });
            });
            // 3.返回所有添加的元素
            return $(res);
        }
    });
    // 筛选相关方法
    njQuery.prototype.extend({
        next: function (sele) {
            var res = [];
            if(arguments.length === 0){
                // 返回所有找到的
                this.each(function (key, value) {
                    var temp = njQuery.get_nextsibling(value);
                    if(temp != null){
                        res.push(temp);
                    }
                });
            }else{
                // 返回指定找到的
                this.each(function (key, value) {
                    var temp = njQuery.get_nextsibling(value)
                    $(sele).each(function (k, v) {
                        if(v == null || v !== temp) return true;
                        res.push(v);
                    });
                });
            }
            return $(res);
        },
        prev: function (sele) {
            var res = [];
            if(arguments.length === 0){
                this.each(function (key, value) {
                    var temp = njQuery.get_previoussibling(value);
                    if(temp == null) return true;
                    res.push(temp);
                });
            }else{
                this.each(function (key, value) {
                    var temp = njQuery.get_previoussibling(value);
                    $(sele).each(function (k, v) {
                        if(v == null || temp !== v) return true;
                        res.push(v);
                    })
                });
            }
            return $(res);
        }
    });
    njQuery.prototype.init.prototype = njQuery.prototype;
    window.njQuery = window.$ = njQuery;
})( window );