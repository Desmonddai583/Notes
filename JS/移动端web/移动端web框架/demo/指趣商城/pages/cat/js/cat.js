$(function () {
    getDefaultCat(function (obj) {
        // 1.初始化分类的头部
        initSearch();
        // 2.初始化分类的菜单
        initMenu(obj.data);
        // 3.初始化底部工具条
        initDefaultNavbar(1);

    }, function (error) {
        alert(error);
    });
});
function initSearch() {
    // 1.利用模板引擎生成对应的界面
    $.ajax({
        url: "./tpl/search.html",
        type: "GET",
        async: false, // 关闭异步
        success: function (htmlTPL) {
            // 1.利用模板引擎的方法生成渲染的函数
            var rander = template.compile(htmlTPL);
            var html = rander();
            $(".layout").append(html);
        },
        error: function () {
            alert("加载数据失败");
        }
    });
}
function initMenu(data) {
    // 1.利用模板引擎生成对应的界面
    $.ajax({
        url: "./tpl/content.html",
        type: "GET",
        async: false, // 关闭异步
        success: function (htmlTPL) {
            // 1.利用模板引擎的方法生成渲染的函数
            var rander = template.compile(htmlTPL);
            var html = rander(data);
            $(".layout").append(html);
            // 2.注册监听事件
            addMenuClick(data);
        },
        error: function () {
            alert("加载数据失败");
        }
    });
    // 初始化侧边栏
    leftScroll = new IScroll('.left-menu',{
        scrollY: true,
    });
    rightmyScroll = new IScroll('.right-menu',{
        scrollY: true,
    });
    // 重新计算滚动的范围
    var timerId =  setInterval(function () {
        if($(".navbar").length !== 0){
            clearInterval(timerId);
            leftScroll.refresh();
        }
    }, 100);

}

/**
 * 监听左侧菜单点击
 * @param data
 */
function addMenuClick(data) {

    $(".left-menu li").click(function () {
        // 设置选中状态
        $(this).addClass("active").siblings().removeClass("active");
        // 移出原有的数据
        $(".right-menu ul").remove();
        // 获取当前点击菜单对应的数据
        var curIndex = $(".left-menu li").index(this);
        var curData = data.list[curIndex];

        var tel = `
                <ul>
                    <% for (var i = 0; i < list.length; i ++) { %>
                    <li>
                        <img src="<%=list[i].pic_url%>" alt="">
                        <p><%=list[i].name%></p>
                    </li>
                    <% } %>
                </ul>
                `;
        var rander = template.compile(tel);
        var html = rander(curData);
        $(".right-menu").append(html);
    });
}