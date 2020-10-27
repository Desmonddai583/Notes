(function () {
    function getRandomIntInclusive(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive
    }

    window.getRandomIntInclusive = getRandomIntInclusive;
})();
/*---------------------------------------------------------------*/
(function () {
    // 0.定义变量保存已经渲染的食物
    var ele = null;

// 1.定义一个食物构造函数
    function Food(options) {
        options = options || {};

        // 食物的位置
        this.x = options.x || 0;
        this.y = options.y || 0;

        // 食物宽度和高度
        this.width = options.width || 50;
        this.height = options.height || 50;

        // 食物的颜色
        this.color = options.color || "red";
    }
// 2.给食物对象添加一个渲染的方法
    Food.prototype.rander = function (map) {
        // 0.删除以前的食物
        if(ele != null){
            ele.parentElement.removeChild(ele)
        }

        // 1.动态的创建一个div元素, 作为食物
        var oDiv = document.createElement("div");
        // 2.将创建的div添加到地图中
        map.appendChild(oDiv);
        ele = oDiv;

        // 3.设置div的位置和宽高等样式
        // 3.1设置宽高
        oDiv.style.width = this.width + "px";
        oDiv.style.height = this.height + "px";
        // 3.2设置颜色和边框
        oDiv.style.backgroundColor = this.color;
        oDiv.style.borderRadius = "50%";
        // 3.3随机设置食物的位置
        // 3.3.1计算水平和垂直方向可以连续放多少个食物
        var rowNum = map.offsetWidth / this.width;
        var colNum = map.offsetHeight / this.height;
        // 3.3.2生成随机数
        // 注意点:
        // 如果map宽度是800, 每个食物是50, 我们可以放16个食物
        // 如果随机数的最大值是16, 那么将来的位置就是16 * 50, 会超出地图
        // 所以随机数的最大值应该是16 - 1
        this.x = getRandomIntInclusive(0, rowNum - 1);
        this.y = getRandomIntInclusive(0, colNum - 1);
        // 3.3.3设置食物的位置
        oDiv.style.position = "absolute";
        oDiv.style.left = this.x * this.width + "px";
        oDiv.style.top = this.y * this.height + "px";
    };

    window.Food = Food;
})();
/*---------------------------------------------------------------*/
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
})();
/*---------------------------------------------------------------*/
(function () {
    // 1.创建一个游戏类
    function Game(options) {
        options = options || {};
        // 1.获取地图
        this.oMap = options.map;
        // 2.创建食物对象
        this.food = new Food();
        // 3.创建蛇对象
        this.snake = new Snake();
    };

// 2.给游戏对象添加一个开始游戏的方法
    Game.prototype.start = function () {
        // 1.渲染蛇和食物
        this.food.rander(this.oMap);
        this.snake.rander(this.oMap);
        /*
        // 定义一个回调函数
        function change() {
            console.log(this);
        }
        // 修改回调函数内部的this为Game对象
        var res = change.bind(this);
        // 2.让蛇动起来
        // 将修改this之后的函数传递给setInterval
        setInterval(res, 1000);
        */
        // 2.让蛇移动
        this.running();

        // 3.通过方向键控制蛇移动
        this.bindKey();
    };
// 3.给游戏对象添加一个让蛇开始移动的方法
    Game.prototype.running = function () {
        var timerId = setInterval((function () {
            // 1.判断蛇有没有超出地图
            var head = this.snake.body[0];
            // 计算蛇最大能移动的x和y
            var maxX = this.oMap.offsetWidth / this.snake.width;
            var maxY = this.oMap.offsetHeight / this.snake.height;
            if(head.x < 0 || head.y < 0 || head.x >= maxX || head.y >= maxY){
                alert("超出了地图");
                // 关闭定时器
                clearInterval(timerId);
                return;
            }
            // 2.判断有没有吃到食物
            if(head.x === this.food.x && head.y === this.food.y){
                // 2.1重新随机生成食物
                this.food.rander(this.oMap);
                // 2.2让蛇新增一节
                this.snake.appendBody();
            }
            // 3.不断的让蛇移动
            this.snake.move(this.oMap);

        }).bind(this), 500)
    };

// 4.给游戏对象添加一个方向控制的方法
    Game.prototype.bindKey = function () {
        var tag = this.snake;
        document.onkeydown = function (e) {
            tag.direction = e.key;
        }
    };

    window.Game = Game;
})();
/*---------------------------------------------------------------*/
var oMap = document.querySelector("#map");
var game = new Game({map: oMap});
game.start();
