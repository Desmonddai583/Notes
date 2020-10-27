$(function () {
    // 初始化其它模块
    initDefaultModule();
    // 初始化底部导航
    initDefaultNavbar(0);
});

/**
 * 初始化默认首页
 */
function initDefaultModule() {
    getDefaultModule(function (obj) {
        var data = obj.data;
        data.module_list.forEach(function (value) {
            // 1.利用模板引擎生成对应的界面
            $.ajax({
                url: "./tpl/"+value.name+".html",
                type: "GET",
                async: false, // 关闭异步
                success: function (htmlTPL) {
                    // 1.利用模板引擎的方法生成渲染的函数
                    var rander = template.compile(htmlTPL);
                    var html = null;
                    // 0.对分类进行特殊处理
                    if(value.name === "single_cat"){
                        // 0.1找到当前分类对应的对象
                        data.cat_list.forEach(function (catObj) {
                            if(catObj.id === value.cat_id){
                                html = rander(catObj);
                            }
                        });
                    }else{
                        // 2.利用模板引擎的方法将数据渲染到模板中
                        html = rander(data);
                    }
                    // 3.将渲染好的结果添加到界面上
                    $(".layout").append(html);
                },
                error: function () {
                    alert("加载数据失败");
                }
            });

            // 2.初始化对应界面的JS效果
            switch (value.name){
                case "banner":
                    initBanner();
                    break;
                case "notice":
                    initNotice();
                    break;
                case "nav":
                    initNav();
                    break;
                case "miaosha":
                    initMiaosha(data);
                    break;
                case "coupon":
                    initCoupon(data);
                    break;
                case "pintuan":
                    initPintuan(data);
                    break;
                case "topic":
                    initTopic();
                    break;
                case "single_cat":
                    initCat();
                    break;

            }
        });
    }, function (error) {
        alert(error);
    });
}

function initBanner() {
    // 2.初始化swiper
    var mySwiper = new Swiper ('.swiper-container', {
        loop: true, // 循环模式选项
        autoplay: true,
        // 如果需要分页器
        pagination: {
            el: '.swiper-pagination',
        },
        observer:true,
        observeParents:true,
    });
}
function initNotice() {
    var $notice = $(".notice-center>span");
    $notice.css({marginLeft: 0});
    $notice.animate({marginLeft: -$notice.width()} ,10000, initNotice);
}
function initNav() {

}
function initMiaosha(data) {
    // 1.初始化倒计时
    // 1.1.获取当前的服务器返回的剩余时间
    var currentTime = data.miaosha.rest_time;
    // 1.2.获取需要操作的元素
    var $tHour = $(".ms-time-hour");
    var $tMin = $(".ms-time-min");
    var $tSec = $(".ms-time-sec");
    // 1.3.开启定时器更新时间
    setInterval(function () {
        var res = fmtTime(currentTime);
        $tHour.text(res.hour);
        $tMin.text(res.min);
        $tSec.text(res.sec);
        currentTime--;
    }, 1000);

    // 2.根据商品的个数动态设置UL的宽度
    // 2.1获取每一个LI的宽度
    var itemWidth = $(".ms-goods-list>li").width() + 1;
    // 2.2计算UL的宽度
    var ulWidth = itemWidth * data.miaosha.goods_list.length;
    // 2.3设置UL的宽度
    $(".ms-goods-list").css({width: ulWidth + "px"});

    // 3.创建ISCROLL
    myScroll = new IScroll('.ms-content',{
        scrollX: true,
        scrollY: false
    });
}
function initCoupon(data) {
    // 1.根据每一张优惠券的宽度计算UL的宽度
    // 1.1获取每一个LI的宽度
    var itemWidth = $(".cp-list>li").width() + 1;
    // 1.2计算UL的宽度
    var ulWidth = itemWidth * data.coupon_list.length;
    // 1.3设置UL的宽度
    $(".cp-list").css({width: ulWidth + "px"});

    // 2.创建IScroll
    myScroll = new IScroll('.cp-content',{
        scrollX: true,
        scrollY: false
    });
}
function initPintuan(data) {
    // 1.根据商品的个数动态设置UL的宽度
    // 1.1获取每一个LI的宽度
    var itemWidth = $(".pt-goods-list>li").width() + 1;
    // 1.2计算UL的宽度
    var ulWidth = itemWidth * data.pintuan.goods_list.length;
    // 1.3设置UL的宽度
    $(".pt-goods-list").css({width: ulWidth + "px"});

    // 2.创建ISCROLL
    myScroll = new IScroll('.pt-content',{
        scrollX: true,
        scrollY: false
    });
}
function initTopic() {
    // 1.初始化Swiper
    var mySwiper = new Swiper ('.topic-content', {
        direction: 'vertical', // 垂直切换选项
        loop: true, // 循环模式选项
        autoplay:true,
    });
}

function initCat() {
    // 1.给分类的所有商品注册点击事件
    $(".cat-list-item").unbind("click");
    $(".cat-list-item").click(function () {
       var goodsId =  $(this).attr("goods-id");
       window.location = "../details/details.html#"+goodsId;
    });
}

