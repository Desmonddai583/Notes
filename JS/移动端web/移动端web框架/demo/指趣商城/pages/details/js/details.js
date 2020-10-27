$(function () {
    var goodsId = window.location.hash.substring(1);
    getGoodsById(goodsId, function (obj) {
        initDetail(obj.data);
    }, function (error) {
        alert(error);
    });
});

function initDetail(data) {
    // 1.利用模板引擎生成对应的界面
    $.ajax({
        url: "./tpl/detail.html",
        type: "GET",
        async: false, // 关闭异步
        success: function (htmlTPL) {
            // 1.利用模板引擎的方法生成渲染的函数
            var rander = template.compile(htmlTPL);
            var html = rander(data);
            $("body").append(html);
        },
        error: function () {
            alert("加载数据失败");
        }
    });

    //  2.初始化Swiper
    var mySwiper = new Swiper ('.swiper-container', {
        loop: true, // 循环模式选项
        autoplay: true,
        // 如果需要分页器
        pagination: {
            el: '.swiper-pagination',
        },
    });
}