window.onload = function () {
    // 1.获取需要操作的元素
    var oMain = document.querySelector(".main");
    var oItems = document.querySelectorAll(".box");

    // 2.实现瀑布流
    waterFull(oMain, oItems);

    // 3.实现数据加载
    loadItems(oMain, oItems);
};
function loadItems(parent, items) {
    // 1.判断是否需要加载数据
    window.onscroll = function () {
        // 1.1获取最后一张图片的位置
        var lastItem = items[items.length - 1];
        var lastHeight = lastItem.offsetTop + lastItem.offsetHeight * 0.5;
        console.log(lastHeight);
        // 1.2获取网页滚动的偏移位
        var pageOffsetTop = getPageScroll().top;
        var screenHeight = getScreen().height;
        // 1.3判断是否需要加载
        if(lastHeight <= screenHeight + pageOffsetTop){
            var arr = [
                {src: "images/img01.jpg"},
                {src: "images/img02.jpg"},
                {src: "images/img03.jpg"},
                {src: "images/img04.jpg"},
                {src: "images/img05.jpg"},
                {src: "images/img06.jpg"},
                {src: "images/img07.jpg"},
                {src: "images/img08.jpg"},
                {src: "images/img09.jpg"},
                {src: "images/img10.jpg"},
            ];
            for(var i = 0, len = arr.length; i < len; i++){
                // 1.创建元素
                var oBox = document.createElement("div");
                oBox.className = "box";
                parent.appendChild(oBox);

                var oPic = document.createElement("div");
                oPic.className = "pic";
                oBox.appendChild(oPic);

                var oImg = document.createElement("img");
                oImg.src = arr[i].src;
                oPic.appendChild(oImg);
            }
            items = document.querySelectorAll(".box");
            // 重新设置布局
            waterFull(parent, items);
        }
    }

}

/**
 * 实现瀑布流的布局
 * @param parent 保存所有内容的大盒子
 * @param items 所有保存每一条信息的小盒子
 */
function waterFull(parent, items) {
     // 1.获取网页可视区域的宽度
    var screenWidth = getScreen().width;
    // 2.获取每一个盒子的宽度
    var itemWidth = items[0].offsetWidth;
    // 3.计算当前可视区域可以显示多少张图片(水平方向)
    var cols = Math.floor(screenWidth / itemWidth);
    // 4.设置main的宽度
    parent.style.width = cols * itemWidth + "px";
    parent.style.margin = "0 auto";

    // 5.定义数组记录第一行盒子的高度
    var heightArr = [];
    var minIndex = 0;
    for(var i = 0, len = items.length; i < len; i++){
        var itemHeight = items[i].offsetHeight;
        // 判断是否是第一行
        if(i < cols){
            // 将第一行所有的高度存储到数组中
            heightArr.push(itemHeight);
        }else{
            // 能执行这里的代码, 代表不是第一行
            // call/ apply  都可以修改函数内部的this
            // call/ apply  都可以给函数传递参数, call逐个传递, apply放到数组中传递
            // call/ apply 都会自动调用
            // Math.min(任意个参数), 会返回传入所有参数的最小值
            // Math.min(3, 5, 7, 1);
            // 查找第一行中最短那个盒子高度
            var minHeight = Math.min.apply(this, heightArr);
            // 查找第一行中最短那个盒子的索引
            var minIndex = getMinIndex(heightArr, minHeight);
            // 查找第一行中最短的那个元素
            var minItem = items[minIndex];
            // 获取该元素的偏移位
            var offsetX = minItem.offsetLeft;

            // 设置下一个元素的位置
            items[i].style.position = "absolute";
            items[i].style.left = offsetX + "px";
            items[i].style.top = minHeight + "px";

            // 更新最矮的高度
            heightArr[minIndex] += items[i].offsetHeight;
        }
    }
}

/**
 * 获取第一行中最短元素的索引
 * @param arr 第一行元素所有的高度
 * @param minHeight  第一行元素最短的高度
 * @returns {number} 最短高度元素的索引
 */
function getMinIndex(arr, minHeight) {
    for(var i = 0, len = arr.length; i < len; i++){
        if(arr[i] === minHeight){
            return i;
        }
    }
    return -1;
}