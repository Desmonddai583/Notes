$(function () {
    // 0.获取到所有的侧边栏
    var $items = $("#myMenu li");
    var currentItem = null;
    var $menu = $("#myMenu");
    var $headerTop = $(".header-top");
    var $headerNav = $(".header-nav");
    // 1.初始化fullpage
    $("#fullpage").fullpage({
        sectionsColor : ['#f0f', '#0f0', '#00f', '#ff0', '#0ff', '#f0f'],
        anchors: ['firstPage', 'secondPage', 'thirdPage', 'fourthPage', 'fivePage', 'sixPage'],
        menu: '#myMenu',
        // 开始滚动就会调用
        // origin当前的页
        // destination 目标页
        onLeave: function (origin, destination) {
            // 控制侧边栏的显示和隐藏
            if(destination.index === 0){
                // 第一页隐藏侧边栏
                $menu.css({
                    display: "none"
                });
                // 第一页显示顶部广告
                $headerTop.css({
                    display: "block"
                });
                // 是第一页让导航条不吸顶
                $headerNav.css({
                    top: '42px'
                });
            }else{
                // 不是第一页显示侧边栏
                $menu.css({
                    display: "block"
                });
                // 不是第一页隐藏顶部广告
                $headerTop.css({
                    display: "none"
                });
                // 不是第一页让导航条吸顶
                $headerNav.css({
                    top: 0
                });
            }
            // 拿到当前页码对应的侧边栏条目
            currentItem = $items.get(destination.index);
        }
    });

    // 2.监听侧边栏的hover事件
    $("#myMenu b").hover(function () {
        // 移入
        // 1.获取到当前hover的B标签对应li
        var $li = $(this).parents("li");
        // 2.判断当前的li是否是显示的
        if(currentItem !== $li.get(0)){
            $(this).parents("li").addClass("active");
        }
    }, function () {
        // 移出
        // 1.获取到当前hover的B标签对应li
        var $li = $(this).parents("li");
        // 2.只有不是当前也的侧边栏条目, 才需要隐藏
        if(currentItem !== $li.get(0)){
            $li.removeClass("active");
        }
    });

    // 3.监听向上按钮的点击事件
    $(".forword").click(function () {
        // 滚动到上一页
        fullpage_api.moveSectionUp();
    });

    // 4.实现第四屏的hover动画
    myHoverAnimation();
});
function myHoverAnimation(){
    // 1.给整个ul中的每个li添加hover事件
    $(".s4-imgs>li").hover(function () {
        // 设置当前hover元素的宽度
        $(this).css({width: "56%"});
        $(this).find("img").css({opacity: 1});

        // 设置非当前hover元素的宽度
        $(this).siblings().css({width: "22%"});
        // 判断当前hover的是否是第一个li
        if(this === $(".s4-img1").get(0)){
            // 修改第一个li中图片的位置
            $(this).find("img").css({left: 0});
        }
        // 判断当前hover的是否是最后一个li
        else if(this === $(".s4-img3").get(0)){
            $(this).find("img").css({right: 0});
        }
    }, function () {
        console.log("离开");
        // 恢复所有li的宽度
        $(".s4-imgs>li").css({width: "33%"});
        $(this).find("img").css({opacity: 0.6});
        // 单独设置第二个li的宽度
        $(".s4-imgs>li").eq(1).css({width: "34%"});
        // 判断当前hover的是否是第一个li
        if(this === $(".s4-img1").get(0)){
            // 修改第一个li中图片的位置
            $(this).find("img").css({left: "-150px"});
        }
        // 判断当前hover的是否是最后一个li
        else if(this === $(".s4-img3").get(0)){
            $(this).find("img").css({right: "-150px"});
        }
    });
}
