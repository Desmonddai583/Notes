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
})()
