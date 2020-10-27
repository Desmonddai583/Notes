/**
 * 格式化时间
 * @param time 需要格式化的时间, 单位是秒
 */
function fmtTime(time) {
    time = time || 0;
    // 计算小时
    var h = parseInt(time / (60 * 60) % 24);
    // 计算分钟
    var m = parseInt(time / 60  % 60);
    // 计算秒钟
    var s = parseInt(time % 60);

    // 对数据进行二次处理
    var obj = {
        hour: (h < 10 ? "0"+ h : h),
        min: (m < 10 ? "0"+ m : m),
        sec: (s < 10 ? "0"+ s : s),
    };

    return obj;
}

/**
 * 添加默认的底部工具条
 * @param index 是第几个界面
 * @param fn 底部工具条初始化完毕的回调
 */
function initDefaultNavbar(index, fn) {
    getDefaultNavbar(function (obj) {
        var data = obj.data;
        // 1.利用模板引擎生成对应的界面
        $.ajax({
            url: "../tpl/navbar.html",
            type: "GET",
            async: false, // 关闭异步
            success: function (htmlTPL) {
                // 1.将index传递给模板
                template.defaults.imports.index = index;
                // 2.利用模板引擎的方法生成渲染的函数
                var rander = template.compile(htmlTPL);
                var html = rander(data);
                $("body").append(html);
                // 3.给有底部工具条的界面添加paddingBottom
                $(".layout").css({paddingBottom: $(".navbar").height() + "px"});
                // 4.执行回调
                fn && fn();
            },
            error: function () {
                alert("加载数据失败");
            }
        });
    }, function (error) {
        alert(error);
    });
}
