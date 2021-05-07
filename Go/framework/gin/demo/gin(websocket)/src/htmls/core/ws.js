let lock=false;
let wsClient;
function reConnect() {
    if (lock) return;
    lock = true;
    console.log("正在重连")
    setTimeout(function() {
        NewClient();
        lock = false;
    }, 2000);
}
//0 - 表示连接尚未建立 1 - 表示连接已建立，可以进行通信。 2 - 表示连接正在进行关闭 3 - 表示连接已经关闭或者连接不能打开
const GetClient=function () {
    if(wsClient!=null && wsClient.readyState===1){
        return wsClient
    }
    NewClient()
    return wsClient
}
const NewClient=function () {
    wsClient = new WebSocket("ws://localhost:8080/echo");
    wsClient.onopen = function(){
        console.log("open");
    }
    wsClient.onclose = function(e){
        console.log("close");
        reConnect()
    }
    wsClient.onerror = function(e){
        console.log(e);
        reConnect()
    }
}




const TYPE_NEWPOD=101;
const NewPod=function (PodName,PodImage,PodNode) {
     return {
         CmdType:TYPE_NEWPOD,
         CmdAction:"add",
         CmdData:{
             PodName,
             PodImage,
             PodNode
         }
     }
}
