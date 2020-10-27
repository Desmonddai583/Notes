$(function () {
    getDefaultCart(function (obj) {
        initHeader();
        initTips();
        initCartList(obj.data);
        initDefaultNavbar(2, function () {
            $(".cart-bottom").css({bottom: $(".navbar").height() + "px"});
        });
    }, function (error) {
        alert(error);
    });
    console.log($(".navbar").height());
});

function initHeader() {
    // 1.利用模板引擎生成对应的界面
    $.ajax({
        url: "./tpl/header.html",
        type: "GET",
        async: false, // 关闭异步
        success: function (htmlTPL) {
            // 1.利用模板引擎的方法生成渲染的函数
            var rander = template.compile(htmlTPL);
            var html = rander();
            $("body").append(html);
        },
        error: function () {
            alert("加载数据失败");
        }
    });
}

function initTips() {
    var tpl = `
    <div class="cart-tips">
    <p>
        <span class="iconfont">&#xe653;</span>
        您正在安全购物环境中，请放心购物
    </p>
    </div>
    `;
    var rander = template.compile(tpl);
    var html = rander();
    $("body").append(html);
}

function initCartList(data) {
    // 1.利用模板引擎生成对应的界面
    $.ajax({
        url: "./tpl/cart-list.html",
        type: "GET",
        async: false, // 关闭异步
        success: function (htmlTPL) {
            // 1.利用模板引擎的方法生成渲染的函数
            var rander = template.compile(htmlTPL);
            var html = rander(data);
            $("body").append(html);
            // 2.添加监听事件
            addCheckedEvent(data);
        },
        error: function () {
            alert("加载数据失败");
        }
    });
}

/**
 * 选中按钮的监听事件
 * @param data 商品数据
 */
function addCheckedEvent() {
    // 1.监听全选按钮的点击
    $(".checked-all").click(function () {
        // 1.监听全选按钮的点击
        if($(this).hasClass("active")){
            $(".checked-all").removeClass("active");
            $(".cart-list-check").removeClass("active");
        }else{
            $(".checked-all").addClass("active");
            $(".cart-list-check").addClass("active");
        }
        // 3.计算商品的价格
        calculatePrice();
    });
    // 2.监听每一个商品的点击
    $(".cart-list-check").click(function () {
        if($(this).hasClass("active")){
            $(this).removeClass("active");
        }else{
            $(this).addClass("active");
        }
        isAll() ?  $(".checked-all").addClass("active") : $(".checked-all").removeClass("active");
        // 3.计算商品的价格
        calculatePrice();
    });
    // 3.监听商品数量按钮的点击
    $(".cart-step-sub").click(function () {
        changeStep(this);
    });
    $(".cart-step-add").click(function () {
        changeStep(this);
    });
}

/**
 * 修改计数器
 * @param self
 */
function changeStep(self) {
    var numItem = $(self).parents(".cart-item-step").find(".num");
    // 1.获取原来的值
    var num = $(numItem).val();
    // 2.加减操作
    if($(self).hasClass("cart-step-sub")){
        num--;
        if(num === 0){return;}
    }else{
        num++;
    }
    // 3.重新赋值
    $(numItem).val(num);

    // 4.重新计算
    calculatePrice();
}

/**
 * 计算商品总价的方法
 */
function calculatePrice() {
    var sum = 0;
    $(".cart-list-item").forEach(function (item) {
        if($(item).find(".cart-list-check").hasClass("active")){
            var price = $(item).find(".price").text();
            var num = $(item).find(".num").val();
            sum += num * price;
        }
    });
    $(".cart-totle-price").text("总价:" + sum);
}

/**
 * 判断是否是全选
 * @returns {boolean} true代表是全选 false代表不是全选
 */
function isAll() {
    var flag = true;
    $(".cart-list-item").forEach(function (ele) {
        if(!$(ele).hasClass("active")){
            flag = false;
        }
    });
    return flag;
}