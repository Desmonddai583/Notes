$(function () {
    // 0.监听内容的时时输入
    $("body").delegate(".comment","propertychange input", function () {
        // 判断是否输入了内容
        if($(this).val().length > 0){
            // 让按钮可用
            $(".send").prop("disabled", false);
        }else{
            // 让按钮不可用
            $(".send").prop("disabled", true);
        }
    });
    // 1.监听发布按钮的点击
    $(".send").click(function () {
        // 拿到用户输入的内容
        var $text = $(".comment").val();
        // 根据内容创建节点
        var $weibo = createEle($text);
        // 插入微博
        $(".messageList").prepend($weibo);
    });

    // 2.监听顶点击
    $("body").delegate(".infoTop", "click", function () {
        $(this).text(parseInt($(this).text()) + 1);
    });
    // 3.监听踩点击
    $("body").delegate(".infoDown", "click", function () {
        $(this).text(parseInt($(this).text()) + 1);
    });
    // 4.监听删除点击
    $("body").delegate(".infoDel", "click", function () {
        $(this).parents(".info").remove();
    });

    // 创建节点方法
    function createEle(text) {
        var $weibo = $("<div class=\"info\">\n" +
            "            <p class=\"infoText\">"+text+"</p>\n" +
            "            <p class=\"infoOperation\">\n" +
            "                <span class=\"infoTime\">"+formartDate()+"</span>\n" +
            "                <span class=\"infoHandle\">\n" +
            "                    <a href=\"javascript:;\" class='infoTop'>0</a>\n" +
            "                    <a href=\"javascript:;\" class='infoDown'>0</a>\n" +
            "                    <a href=\"javascript:;\" class='infoDel'>删除</a>\n" +
            "                </span>\n" +
            "            </p>\n" +
            "        </div>");
        return $weibo;
    }

    // 生成时间方法
    function formartDate() {
        var date = new Date();
        // 2018-4-3 21:30:23
        var arr = [date.getFullYear() + "-",
            date.getMonth() + 1 + "-",
            date.getDate() + " ",
            date.getHours() + ":",
            date.getMinutes() + ":",
            date.getSeconds()];
        return arr.join("");

    }
});