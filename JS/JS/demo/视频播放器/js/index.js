window.onload = function () {
    // 1.获取到需要操作的元素
    var oVideo = document.querySelector("video");
    var oBox = document.querySelector("figure");
    var oTotalEle = document.querySelector(".totalTime");
    var oPlay = document.querySelector(".play");
    var oCurEle = document.querySelector(".curTime");
    var oLine = document.querySelector(".line");
    var oProgress = document.querySelector(".progress");
    var oFullBtn = document.querySelector(".full");

    // 2.监听video是否可以播放
    oVideo.oncanplay = function () {
        // 2.1移出加载背景图片
        oBox.style.background = "none";
        // 2.2显示视频
        oVideo.style.display = "block";

        // 2.3获取当前视频的总时长(秒)
        var totalTime = oVideo.duration;
        oTotalEle.innerHTML = formartTime(totalTime);
    }

    // 3.监听播放按钮的点击
    oPlay.onclick = function () {
        var flag = oPlay.playing || false;
        console.log(flag);
        // 3.1切换播放图标
        if(flag){
            this.innerHTML = "&#xe66a;";
            oPlay.playing = false;
            // 3.2让视频播放
            oVideo.pause();
        }else {
            // 3.1切换播放按钮的图标
            this.innerHTML = "&#xe638;";
            oPlay.playing = true;
            // 3.2让视频播放
            oVideo.play();
        }
        return false;
    };

    // 4.监听视频播放的变化
    // 只要视频在播放, 这个事件就会不断的被触发
    oVideo.ontimeupdate = function () {
        // 4.1获取当前播放的时间
        var curTime = this.currentTime;
        // 4.2设置当前的时间
        oCurEle.innerHTML = formartTime(curTime);
        // 4.3修改进度条
        // 进度条的宽度  = 当前时间 / 总时间 * 100;
        //                60     /   60   == 1  * 100
        var lineWidth = curTime / this.duration * 100;
        oLine.style.width = lineWidth + "%";
    };

    // 5.监听进度条的点击
    oProgress.onclick = function (event) {
        event = event || window.event;
        // 点击的位置 / bar的长度 = 跳转的时长 /  总时长
        // 点击的位置 / bar的长度 * 总时长 = 跳转的时长
        var jumpTime = event.offsetX / this.offsetWidth * oVideo.duration;
        oVideo.currentTime = jumpTime;
    };

    // 6.监听视频播放完毕
    oVideo.onended = function () {
        // 1.重置播放按钮
        oPlay.innerHTML = "&#xe66a;";
        oPlay.playing = false;
        // 2.重置播放时间
        oCurEle.innerHTML = "00:00:00";
        oTotalEle.innerHTML = "00:00:00";
        // 3.重置进度条
        oLine.style.width = "0px";
    };

    // 7.监听全屏按钮的点击
    oFullBtn.onclick = function () {
        // oVideo.style.width = getScreen().width + "px";
        // oVideo.style.height = getScreen().height + "px";
        oVideo.webkitRequestFullScreen();
    }
};

/**
 * 格式化事件
 * @param time 需要格式化的时间
 * @returns {string} 格式化之后的时间
 */
function formartTime(time) {
    // 1.计算小时
    // 秒 / 60 = 分钟 / 60 = 小时
    var h = parseInt(time / 60 / 60);
    // 2.计算分数
    // 秒 / 60 = 分钟 % 60 = 剩余分数
    var m = parseInt(time / 60 % 60);
    // 3.计算秒钟
    // 秒 % 60 = 剩余秒
    var s = parseInt(time % 60);
    // 00:00:00
    return  (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
}