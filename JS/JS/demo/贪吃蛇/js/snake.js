(function () {
    // 0.定义一个数组, 用于保存界面上已经渲染的蛇
    var elements = [];

// 1.定义一个蛇类
    function Snake(options) {
        options = options || {};

        // 每一节蛇宽度和高度
        this.width = options.width || 50;
        this.height = options.height || 50;

        // 蛇行走的后方向
        // up down left right
        this.direction = "ArrowRight";

        // 默认的蛇长度
        this.body = [
            {x: 3, y: 2, color: "red"}, // 蛇头
            {x: 2, y: 2, color: "blue"}, // 第一节蛇身
            {x: 1, y: 2, color: "blue"} // 第二节蛇身
        ];
    }

// 2.给蛇对象添加一个渲染的方法
    Snake.prototype.rander = function (map) {
        // 0.清空上一次渲染的蛇
        // this.remove();
        remove();

        // 1.创建所有的蛇的身体
        for(var i = 0; i < this.body.length; i++){
            // 1.1创建一个div作为蛇身体的一部分
            var oDiv = document.createElement("div");

            // 1.2设置div的样式和属性
            var obj = this.body[i];
            oDiv.style.width = this.width + "px";
            oDiv.style.height = this.height + "px";
            oDiv.style.backgroundColor = obj.color;
            oDiv.style.borderRadius = "50%";
            oDiv.style.position = "absolute";
            oDiv.style.left = obj.x * this.width + "px";
            oDiv.style.top = obj.y * this.height + "px";
            oDiv.innerText = i;
            // 1.3将当前创建好的蛇的身体添加到地图上
            map.appendChild(oDiv);
            // 1.4将当前渲染到界面上的身体保存到数组中
            elements.push(oDiv);
        }
    };

// 3.给蛇添加一个删除自己的方法
//     Snake.prototype.remove = function(){
//     var remove = function(){
    function remove(){
        for(var i = elements.length - 1; i >= 0; i--){
            var oDiv = elements[i];
            // 1.将蛇元素从界面上删除
            oDiv.parentElement.removeChild(oDiv);
            // 2.将蛇元素从数组中删除
            elements.splice(i, 1);
        }
    };

// 3.给蛇添加一个移动的方法
    Snake.prototype.move = function (map){
        // 1.让蛇身移动,从最后一节蛇身体开始移动, 让后一节身体等于前一节身体的值
        for(var i = this.body.length - 1; i > 0; i--){
            this.body[i].x = this.body[i - 1].x;
            this.body[i].y = this.body[i - 1].y;
        }

        // 2.让蛇头移动
        var head = this.body[0];
        switch (this.direction){
            case "ArrowUp":
                // head.y = head.y - 1;
                head.y -= 1;
                break;
            case "ArrowDown":
                head.y += 1;
                break;
            case "ArrowLeft":
                head.x -= 1;
                break;
            case "ArrowRight":
                head.x += 1;
                break;
        }
        // 重新渲染蛇
        this.rander(map);
    };

// 4.给蛇添加一个增加一节身体的方法
    Snake.prototype.appendBody = function () {
        var obj = this.body[this.body.length - 1];
        var newBody = {};
        switch (this.direction){
            case "ArrowUp":
                newBody.x = obj.x;
                newBody.y = obj.y - 1;
                newBody.color = obj.color;
                break;
            case "ArrowDown":
                newBody.x = obj.x;
                newBody.y = obj.y + 1;
                newBody.color = obj.color;
                break;
            case "ArrowLeft":
                newBody.x = obj.x + 1;
                newBody.y = obj.y;
                newBody.color = obj.color;
                break;
            case "ArrowRight":
                newBody.x = obj.x - 1;
                newBody.y = obj.y;
                newBody.color = obj.color;
                break;
        }
        this.body.push(newBody);
    };

    window.Snake = Snake;
})()


