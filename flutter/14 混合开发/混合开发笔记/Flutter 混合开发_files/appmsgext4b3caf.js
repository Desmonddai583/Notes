define("pages/qqmusic_ctrl.js",["biz_wap/utils/jsmonitor_report.js","pages/player_adaptor.js","biz_wap/jsapi/log.js","biz_wap/utils/ajax.js","pages/musicUrlReport.js"],function(e){
"use strict";
function r(e,r){
if(/^http(s)?:\/\//i.test(e.albumurl)){
for(var t,a=[/^http(s)?:\/\/imgcache\.qq\.com([\/?].*)*$/i,/^http(s)?:\/\/y\.gtimg\.cn([\/?].*)*$/i],s=!1,i=0;t=a[i++];)if(t.test(e.albumurl)){
s=!0;
break;
}
s||(e.albumurl="");
}else{
var o=e.albumurl.split("/");
try{
o=o[o.length-1],o=o.split(".")[0];
}catch(n){
o="";
}
e.albumurl=o?m.imgroot2.replace("#mid#",o):m.imgroot+e.albumurl;
}
return e.albumurl=e.albumurl.replace("mid_album_68","mid_album_90").replace("68x68","90x90"),
e.musicIcon=m.musicIcon,e.type=1*r.scene===0?0:1*r.scene===1?1:8,c.inQMClient?(e.allowPause=!0,
e.detailUrl="",e.pauseCss="qqmusic_playing_pause",e.webUrl=e.detailUrl):(e.allowPause=!1,
e.pauseCss="",e.detailUrl=["http://i.y.qq.com/v8/playsong.html?referFrom=music.qq.com&songid=",e.musicid,"&songmid=",e.media_id,,"&ADTAG=weixin_gzh#wechat_redirect"].join(""),
e.webUrl=e.detailUrl),e;
}
function t(e,r){
var t=e,a=m.cache[t.songId];
return c.inQMClient?void r.callback({
canplay:!0,
play_url:"https://www.qq.com"
}):a&&"function"==typeof r.callback&&(a.canplay||!a.canplay&&!a.retry)?(a.in_cache=!0,
void r.callback(a)):void(m.submiting[t.songId]!==!0&&(m.submiting[t.songId]=!0,a&&o.setSum(m.reportId,122,1),
s({
id:t.songId,
mid:t.mid,
onSuc:function(e){
m.submiting[t.songId]=!1,m.cache[t.songId]&&!m.cache[t.songId].canplay&&e.canplay&&o.setSum(m.reportId,123,1),
m.cache[t.songId]=e,"function"==typeof r.callback&&r.callback(e);
},
onError:function(){
m.submiting[t.songId]=!1,"function"==typeof r.callback&&r.callback({
canplay:!1,
msg:"系统繁忙，请稍后再试。",
status:-1,
play_url:"",
duration:0
});
}
})));
}
function a(e){
var r=!0,t=!1,a="";
switch(1*e){
case 0:
r=!0;
break;

case 1:
r=!1,a="因版权限制，音乐无法播放。";
break;

case 2:
r=!1,a="因版权限制，音乐无法播放。";
break;

case 3:
r=!1,a="因版权限制，音乐无法播放。";
break;

case 4:
r=!1,a="当前区域因版权限制，音乐无法播放。";
break;

case 5:
r=!1,t=!0,a="播放失败，请稍后再试。";
break;

case 6:
r=!1,t=!0,a="系统错误，请稍后再试。";
break;

case 7:
r=!1,t=!0,a="系统错误，请稍后再试。";
break;

case 8:
r=!0,a="该音乐为付费音乐，当前为你播放试听片段。";
break;

default:
r=!1,a="系统错误，请稍后再试。";
}
return{
canplay:r,
msg:a,
retry:t
};
}
function s(e){
o.setSum(m.reportId,18,1);
var r=+new Date,t="//mp.weixin.qq.com/mp/qqmusic?action=get_song_info&song_mid=#mid#";
t=t.replace("#mid#",e.mid),p({
url:t,
type:"GET",
dataType:"json",
success:function(t){
var s=+new Date-r;
if(200==t.http_code){
setTimeout(function(){
u.reportRespData({
type:1,
songid:e.id,
musicid:e.mid,
responseData:t.resp_data||""
});
},0);
var o={};
try{
o=JSON.parse(t.resp_data);
}catch(c){
var p=1;
return i({
type:"error",
time:s,
code:p
}),"function"==typeof e.onError&&e.onError({
errcode:p
}),void n.info("qqmusic_checkCopyright_parsefail mid:"+e.mid+", repsponeData:"+t.resp_data);
}
if("undefined"==typeof o.ret||0!=o.ret||0!=o.sub_ret||0==o.songlist.length){
var p=1;
return i({
type:"error",
time:s,
code:p
}),"function"==typeof e.onError&&e.onError({
errcode:p
}),void n.info("qqmusic_checkCopyright_dataerror mid:"+e.mid+", repsponeData:"+t.resp_data);
}
var m,l=o.songlist[0],d=l.song_play_url,b=l.song_play_time||0;
if(l.playable)m=d?0:6;else if(l.try_playable)l.try_file_size>0&&l.try_30s_url?(m=8,
d=l.try_30s_url,b=30):m=7;else switch(1*l.unplayable_code){
case 1:
m=1;
break;

case 2:
m=2;
break;

case 3:
m=3;
break;

case 4:
m=4;
break;

case 5:
m=5;
break;

default:
m=5;
}
i({
type:"success",
time:s,
code:m
});
var y=a(1*m);
e.onSuc({
canplay:y.canplay,
retry:y.retry,
msg:y.msg,
status:m,
play_url:d||"",
duration:b
}),y.canplay||n.info("qqmusic_checkCopyright_cannotplay mid:"+e.mid+", repsponeData:"+t.resp_data);
}else{
var p=4;
switch(t.http_code){
case 200:
break;

case 400:
p=2;
break;

case 500:
p=3;
break;

default:
p=4;
}
i({
type:"error",
time:s,
code:p
}),"function"==typeof e.onError&&e.onError({
errcode:p
});
}
},
error:function(){
"function"==typeof e.onError&&e.onError({
errcode:4
});
}
});
}
function i(e){
var r=Math.max(e.time,0);
if(r=Math.min(r,6e4),e.time>=0&&e.time<200?o.setSum(m.reportId,24,1):e.time>=200&&e.time<500?o.setSum(m.reportId,25,1):e.time>=500&&e.time<1e3?o.setSum(m.reportId,26,1):e.time>=1e3&&e.time<2e3?o.setSum(m.reportId,27,1):e.time>=2e3&&e.time<1e4?o.setSum(m.reportId,28,1):e.time>=1e4&&o.setSum(m.reportId,29,1),
o.setAvg(m.reportId,23,r),"error"==e.type){
switch(1*e.code){
case 1:
o.setSum(m.reportId,9,1);
break;

case 2:
o.setSum(m.reportId,10,1);
break;

case 3:
o.setSum(m.reportId,11,1);
break;

case 4:
o.setSum(m.reportId,12,1);
}
o.setSum(m.reportId,19,1);
}else if("success"==e.type){
switch(1*e.code){
case 1:
o.setSum(m.reportId,8,1);
break;

case 0:
o.setSum(m.reportId,17,1);
break;

case 2:
o.setSum(m.reportId,13,1);
break;

case 3:
o.setSum(m.reportId,14,1);
break;

case 4:
o.setSum(m.reportId,15,1);
break;

case 5:
o.setSum(m.reportId,16,1);
break;

case 6:
o.setSum(m.reportId,47,1);
break;

case 7:
o.setSum(m.reportId,120,1);
break;

case 8:
o.setSum(m.reportId,121,1);
}
o.setSum(m.reportId,20,1);
}
}
var o=e("biz_wap/utils/jsmonitor_report.js"),c=e("pages/player_adaptor.js"),n=e("biz_wap/jsapi/log.js"),p=e("biz_wap/utils/ajax.js"),u=e("pages/musicUrlReport.js"),m={
imgroot:"https://imgcache.qq.com/music/photo/mid_album_90",
imgroot2:"https://y.gtimg.cn/music/photo_new/T002R90x90M000#mid#.jpg",
reportId:"28306",
musicIcon:window.icon_qqmusic_source||"",
cache:{},
submiting:{}
};
return{
initData:r,
getPlayUrl:t
};
});define("pages/voice_component.js",["biz_common/dom/event.js","biz_common/tmpl.js","pages/music_player.js","pages/player_adaptor.js","biz_common/dom/class.js","pages/report.js","pages/music_report_conf.js","pages/player_tips.js","biz_wap/jsapi/leaveReport.js","biz_wap/utils/mmversion.js","biz_wap/utils/ajax.js","biz_wap/utils/openUrl.js","pages/qqmusic_ctrl.js","pages/kugoumusic_ctrl.js"],function(e){
"use strict";
function t(){
C.hasInit||(n(),r(),s(),C.hasInit=!0);
}
function a(e){
t(),this._o={
protocal:"",
wxIndex:0,
type:0,
comment_id:"",
src:"",
jsapi2Src:"",
mid:"",
songId:"",
otherid:"",
albumid:"",
jumpurlkey:"",
autoPlay:!1,
duration:0,
needVioceMutex:!0,
appPlay:!0,
title:"",
allowPause:!1,
singer:"",
epname:"",
coverImgUrl:"",
webUrl:[location.protocol,"//mp.weixin.qq.com/s?referFrom=#referFrom#&songid=#songId#&__biz=",window.biz,"&mid=",window.mid,"&idx=",window.idx,"&sn=",window.sn,"#wechat_redirect"].join(""),
musicbar_url:"",
playingCss:"",
pauseCss:"",
playCssDom:"",
playArea:"",
progress:"",
detailUrl:"",
detailArea:"",
fileSize:0,
playtimeDom:"",
loadingDom:"",
bufferDom:"",
playdotDom:"",
seekRange:"",
seekContainer:""
},this._init(e),C.allComponent.push(this);
}
function o(e,t,a,o){
C.num++,t.musicSupport=C.musicSupport,t.show_not_support=!1,C.musicSupport||1!=C.num||(t.show_not_support=!0);
var r=document.createElement("div"),n="";
if(n=y.tmpl(e,t),r.innerHTML=n,o===!0)a.appendChild(r.children[0]);else{
var i=a.parentNode;
if(!i)return;
i.lastChild===a?i.appendChild(r.children[0]):i.insertBefore(r.children[0],a.nextSibling);
}
}
function r(){
C.hasInit||h.inQMClient&&i("QMClient_pv",1);
}
function n(){
window.reportMid=[],window.reportVoiceid=[];
for(var e in v)if(v.hasOwnProperty(e)){
var t=v[e],a=t.split("_");
C.reportData2[e]={
id:a[0],
key:a[1],
count:0
};
}
}
function i(e,t){
C.reportData2[e]&&(t=t||1,C.reportData2[e].count+=t,C.debug&&console.log("addpv:"+e+" count:"+C.reportData2[e].count));
}
function s(){
x.gtVersion("7.0.6")||g.on(window,"unload",function(){
for(var e=p(),t=JSON.parse(e.report_list),a=0;a<t.length;a++)I({
type:"POST",
url:"/mp/musicreport?#wechat_redirect",
timeout:2e4,
async:!0,
data:t[a]
});
}),C.repotIntervalId&&clearInterval(C.repotIntervalId),C.repotIntervalId=setInterval(function(){
l();
},3e4);
}
function p(){
m.triggerUnloadPlaying(),l();
for(var e,t={},a=0,o=C.allComponent.length;o>a;a++){
var r=C.allComponent[a];
r.player&&"function"==typeof r.player.getPlayTotalTime&&(C.reportData[r._o.type].play_last_time[r._g.posIndex]=parseInt(1e3*r.player.getPlayTotalTime())),
"number"!=typeof r._status||1!==r._status&&4!==r._status||(e=r._o.songId);
}
e&&(t.current_musicid=e);
var i=[];
for(var a in C.reportData)i=i.concat(D.musicreport({
data:C.reportData[a]
}));
t.report_list=JSON.stringify(i),n();
for(var a=0,o=C.allComponent.length;o>a;a++){
var r=C.allComponent[a];
r&&"function"==typeof r._initReportData&&r._initReportData(),r.player&&"function"==typeof r.player.resetPlayTotalTime&&r.player.resetPlayTotalTime();
}
return t;
}
function l(){
var e=[];
for(var t in C.reportData2)if(C.reportData2.hasOwnProperty(t)){
var a=C.reportData2[t];
a.count>0&&(e.push(a.id+"_"+a.key+"_"+a.count),a.count=0);
}
e.length>0&&I({
type:"POST",
url:"/mp/jsmonitor?#wechat_redirect",
timeout:2e4,
async:!1,
data:{
idkey:e.join(";"),
t:Math.random()
}
});
}
function c(e){
return new a(e);
}
function d(e){
if(isNaN(e))return"00:00";
e=Math.floor(e);
var t=Math.floor(e/3600),a=Math.floor((e-3600*t)/60),o=e-3600*t-60*a;
return 0!=t?(10>t&&(t="0"+t),t+=":"):t="",10>a&&(a="0"+a),10>o&&(o="0"+o),t+a+":"+o;
}
function u(e){
return e=(e||"").replace(/&#96;/g,"`").replace(/&#61;/g,"=").replace(/&#39;/g,"'").replace(/&quot;/g,'"').replace(/&lt;/g,"<").replace(/&gt;/g,">").replace(/&amp;/g,"&");
}
function _(e){
return e=(e||"").replace(/&/g,"&amp;").replace(/>/g,"&gt;").replace(/</g,"&lt;").replace(/"/g,"&quot;").replace(/'/g,"&#39;").replace(/=/g,"&#61;").replace(/`/g,"&#96;");
}
var g=e("biz_common/dom/event.js"),y=e("biz_common/tmpl.js"),m=e("pages/music_player.js"),h=e("pages/player_adaptor.js"),f=e("biz_common/dom/class.js"),D=e("pages/report.js"),v=e("pages/music_report_conf.js"),w=e("pages/player_tips.js"),k=e("biz_wap/jsapi/leaveReport.js"),x=e("biz_wap/utils/mmversion.js"),I=e("biz_wap/utils/ajax.js"),b=e("biz_wap/utils/openUrl.js").openUrlWithExtraWebview,C={
allComponent:[],
hasInit:!1,
reportId:"28306",
musicSupport:m.getSurportType(),
debug:location.href.indexOf("vconsole=1")>0||document.cookie&&document.cookie.indexOf("vconsole_open=1")>-1?!0:!1,
reportData:{},
posIndex:{},
num:0,
reportData2:{},
adapter:{
m:e("pages/qqmusic_ctrl.js"),
k:e("pages/kugoumusic_ctrl.js")
},
needReport11982:!1,
repotIntervalId:null
};
return a.prototype._init=function(e){
this._extend(e),this._g={
posIndex:void 0,
tag:"",
canDragBar:!1,
barDraging:!1,
canGoDetail:!0
},5==this._o.type||6==this._o.type||9==this._o.type?this._g.tag="k":this._o.type>=2&&this._o.type<=4?this._g.tag="v":7==this._o.type?this._g.tag="a":(0==this._o.type||1==this._o.type||8==this._o.type)&&(this._g.tag="m"),
this._initData(),this._initQQmusicLyric(),this._initReportData(),this._initPlayer();
},a.prototype._initData=function(){},a.prototype._initQQmusicLyric=function(){
var e=this._o,t=this._g;
e.webUrl="m"==t.tag?e.webUrl.replace("#songId#",e.songId||"").replace("#referFrom#","music.qq.com"):e.webUrl.replace("#songId#","").replace("#referFrom#","");
},a.prototype._initReportData=function(){
var e=this._o,t=this._g;
"v"==t.tag?window.reportVoiceid.push(e.songId):"m"==t.tag&&window.reportMid.push(e.songId),
"undefined"==typeof C.reportData[e.type]&&(C.reportData[e.type]=D.getMusicReportData(e),
C.posIndex[e.type]=0),"undefined"==typeof t.posIndex&&(t.posIndex=C.posIndex[e.type]++);
var a=C.reportData[e.type];
a.musicid[t.posIndex]=e.songId,a.commentid[t.posIndex]=e.comment_id,a.hasended[t.posIndex]=0,
a.mtitle[t.posIndex]=e.title,a.detail_click[t.posIndex]=0,a.duration2[t.posIndex]=parseInt(1e3*e.duration),
a.errorcode[t.posIndex]=0,a.play_duration2[t.posIndex]=0,a.seek[t.posIndex]=0,a.seek_position[t.posIndex]=[],
a.play_last_time[t.posIndex]=0,a.local_time[t.posIndex]=0,a.seek_loaded[t.posIndex]=[];
},a.prototype._initPlayer=function(){
if(C.musicSupport){
var e=this,t=this._o,a=this._g.tag;
t.onStatusChange=this._statusChangeCallBack(),t.onTimeupdate=this._timeupdateCallBack(),
t.onError=this._errorCallBack(),t.onUpdateSeekRange=this._onUpdateSeekRange(),t.onAndroidForceH5=function(){
i("force_h5",1);
},t.onH5Begin2Play=function(){
i(a+"_pv",1),i(a+"_h5_pv",1);
},t.onH5Error=function(t,o){
i(a+"_h5_err_total",1),i(a+"_h5_err_"+o.code,1),e._reportH5Error({
type:1,
code:o.code
});
},t.onJsapi1Begin2Play=function(){
i(a+"_pv",1),i(a+"_wx_pv",1),i(a+"_wx_pv_1",1);
},t.onJsapi2Begin2Play=function(e,o){
i(a+"_pv",1),i(a+"_wx_pv",1),i(a+"_wx_pv_2",1),t.jsapi2Src&&t.jsapi2Src!=t.src&&i("aac_pv",1),
t.musicPlayerOnJsapi2Begin2Play&&t.musicPlayerOnJsapi2Begin2Play(o);
},t.onJsapi2PlaySuccess=function(e,a){
t.musicPlayerOnJsapi2PlaySuccess&&t.musicPlayerOnJsapi2PlaySuccess(a);
},t.onJsapi2Begin2PlayErr=function(){
if(i(a+"_wx_err_1",1),t.jsapi2Src&&t.jsapi2Src!=t.src){
var e="acc_start_error;type:#type#;uin:"+(window.user_uin||"")+";playurl:"+t.jsapi2Src+";pageurl:"+location.href;
m.isAndroid?(D.logReport("",e.replace("#type#","android"),"ajax"),i("android_aac_err_1",1)):(D.logReport("",e.replace("#type#","ios"),"ajax"),
i("ios_aac_err_1",1));
}
},t.onJsapi2PlayingErr=function(){
if(i(a+"_wx_err_2",1),t.jsapi2Src&&t.jsapi2Src!=t.src){
var e="acc_ing_error;type:#type#;uin:"+(window.user_uin||"")+";playurl:"+t.jsapi2Src+";pageurl:"+location.href;
m.isAndroid?(D.logReport("",e.replace("#type#","android"),"ajax"),i("android_aac_err_2",1)):(D.logReport("",e.replace("#type#","ios"),"ajax"),
i("ios_aac_err_2",1));
}
},t.onJsapi2PlayingStop=function(){
var e=a+"_stoped_";
e+=m.isAndroid?"android":"ios",i(e,1);
},t.onJsapi2PlayingPause=function(){
var e=a+"_paused_";
e+=m.isAndroid?"android":"ios",i(e,1);
},t.onSeekErr=function(){
if(i(a+"_seek_err",1),t.jsapi2Src&&t.jsapi2Src!=t.src){
var e="acc_seek_error;type:#type#;uin:"+(window.user_uin||"")+";playurl:"+t.jsapi2Src+";pageurl:"+location.href;
m.isAndroid?(D.logReport("",e.replace("#type#","android"),"ajax"),i("android_aac_err_3",1)):(D.logReport("",e.replace("#type#","ios"),"ajax"),
i("ios_aac_err_3",1));
}
},t.onUnloadPlaying=function(){
i(a+"_unload_wx_pv",1);
},t.onQMClientPlay=function(){
i("QMClient_play",1);
},t.onSeekNeed2Load=function(){
if(e.player&&e.player.surportSeekRange()&&t.playdotDom){
var a=C.reportData[e._o.type],o=a.seek_position[e._g.posIndex].length;
o>0&&(a.seek_loaded[e._g.posIndex][o-1]=1);
}
},t.onSeekNotNeed2Load=function(){
if(e.player&&e.player.surportSeekRange()&&t.playdotDom){
var a=C.reportData[e._o.type],o=a.seek_position[e._g.posIndex].length;
o>0&&(a.seek_loaded[e._g.posIndex][o-1]=0);
}
},h.create(this._o,{
callback:function(t){
e.player=t,e.afterCreatePlayer();
}
});
}
},a.prototype.afterCreatePlayer=function(){
this._playEvent();
},a.prototype.isInSeekrang=function(e){
var t=this._o.seekRange;
if(!t)return!1;
if(t===e)return!0;
for(var a=t.getElementsByTagName("*"),o=0,r=a.length;r>o;o++)if(a[o]===e)return!0;
return!1;
},a.prototype._playEvent=function(){
var e=this,t=this._o,a=this._g;
if(t.detailUrl&&t.detailArea&&g.on(t.detailArea,"click",function(o){
if(!a.barDraging&&a.canGoDetail){
var r=o.target||o.srcElement;
r&&e.isInSeekrang(r)||("v"==a.tag?(C.reportData[t.type].detail_click[a.posIndex]=1,
window.__second_open__?b(t.detailUrl):window.location.href=t.detailUrl):("m"==a.tag||"k"==a.tag)&&C.adapter[a.tag].getPlayUrl(t,{
callback:function(e){
e.canplay?(C.reportData[t.type].detail_click[a.posIndex]=1,window.__second_open__?b(t.detailUrl):window.location.href=t.detailUrl):e.msg&&new w({
msg:e.msg
});
}
}));
}
}),C.musicSupport){
var o=0,r=4,n=5;
switch(1*t.type){
case 0:
o=1;
break;

case 1:
o=13;
break;

case 8:
o=14;
break;

case 2:
o=3;
break;

case 3:
o=6;
break;

case 4:
o=7;
break;

case 5:
o=10;
break;

case 6:
o=15;
break;

case 7:
o=11;
break;

case 9:
o=12;
}
var i="";
i=t.allowPause?t.pauseCss||t.playingCss:t.playingCss,g.tap(t.playArea,function(){
return console.log("click playArea",f.hasClass(t.playCssDom,i)),f.hasClass(t.playCssDom,i)?(t.allowPause?e.player.pause():e.player.stop(),
D.report({
type:o,
comment_id:t.comment_id,
voiceid:t.songId,
action:n
})):"v"==a.tag||"a"==a.tag?e._playMusic(o,r):C.adapter[a.tag].getPlayUrl(t,{
callback:function(n){
n.canplay&&n.play_url?(n.duration&&(t.duration=n.duration,e.player.setDuration(t.duration),
C.reportData[t.type].duration2[a.posIndex]=parseInt(1e3*t.duration)),e.player.setSrc(n.play_url),
8!=n.status||n.in_cache?e._playMusic(o,r):new w({
msg:"该音乐为付费音乐，当前为你播放试听片段",
onClick:function(){
e._playMusic(o,r);
}
})):n.msg&&new w({
msg:n.msg
});
}
}),!1;
}),e._dragEvent();
}
},a.prototype.getSeekRangeOffsetLeft=function(){
var e=0,t=this._o.seekRange,a=!1,o=window.__zoom||1;
for(1!=o&&(a=!0);t&&t!=document.body;)e+=a?t.offsetLeft*o:t.offsetLeft,"page-content"==t.id&&(a=!1),
t=t.offsetParent;
return e;
},a.prototype._dragEvent=function(){
var e=this,t=this._o,a=this._g,o=t.seekRange;
if(o){
var r=e.player.getDuration();
a.seekData={
zoom:window.__zoom||1,
duration:r,
startTime:0,
dragTime:0,
downX:0,
moveX:0
},g.on(o,"mousedown",function(t){
a.canDragBar&&(e._pointerDownHandler({
x:t.pageX||t.clientX
}),t.preventDefault());
}),g.on(t.seekContainer,"mousemove",function(t){
a.canDragBar&&a.barDraging&&(e._pointerMoveHandler({
x:t.pageX||t.clientX
}),t.preventDefault(),t.stopPropagation());
}),g.on(document.body,"mouseup",function(t){
return a.canDragBar&&a.barDraging?(e._pointerUpHandler({
x:t.pageX||t.clientX
}),t.preventDefault(),t.stopPropagation(),!1):void 0;
}),g.on(o,"touchstart",function(t){
a.canDragBar&&(e._pointerDownHandler({
x:t.changedTouches[0].clientX
}),t.preventDefault());
}),g.on(o,"touchmove",function(t){
a.canDragBar&&a.barDraging&&(e._pointerMoveHandler({
x:t.changedTouches[0].clientX
}),t.preventDefault(),t.stopPropagation());
}),g.on(o,"touchend",function(t){
return a.canDragBar&&a.barDraging?(e._pointerUpHandler({
x:t.changedTouches[0].clientX
}),t.preventDefault(),t.stopPropagation(),!1):void 0;
});
}
},a.prototype._pointerDownHandler=function(e){
var t=this._g;
t.barDraging=!0,t.canGoDetail=!1,t.seekData.downX=e.x,t.seekData.startTime=this.player.getCurTime();
},a.prototype._pointerMoveHandler=function(e){
var t=this._g,a=t.seekData;
a.moveX=e.x;
var o=this.getSeekRangeOffsetLeft(),r=(a.moveX-o)/a.zoom/this._o.seekRange.offsetWidth;
r=Math.min(r,1),r=Math.max(r,0),a.dragTime=r*a.duration,a.dragTime!=a.startTime&&this._updateProgressBar(a.dragTime);
},a.prototype._pointerUpHandler=function(e){
var t=this._g,a=t.seekData;
a.dragTime||this._pointerMoveHandler({
x:e.x
}),t.barDraging=!1,this.player.seek(a.dragTime),C.reportData[this._o.type].seek[t.posIndex]=1,
C.reportData[this._o.type].seek_position[t.posIndex].push(parseInt(1e3*a.startTime)+","+parseInt(1e3*a.dragTime));
var o=C.reportData[this._o.type].seek_position[t.posIndex].length;
C.reportData[this._o.type].seek_loaded[t.posIndex][o-1]=0,t.seekData.startTime=0,
t.seekData.dragTime=0,t.seekData.downX=0,t.seekData.moveX=0,setTimeout(function(){
t.canGoDetail=!0;
},1e3);
},a.prototype._playMusic=function(e,t){
var a=this._o,o=this._g;
this.player.play(),C.reportData[a.type].hasended[o.posIndex]=1,0==C.reportData[a.type].local_time[o.posIndex]&&(C.reportData[a.type].local_time[o.posIndex]=parseInt(+new Date/1e3)),
D.report({
type:e,
comment_id:a.comment_id,
voiceid:a.songId,
action:t
}),x.gtVersion("7.0.6")&&!C.needReport11982&&(C.needReport11982=!0,k.addSpecificReport("music_data",p),
console.log("music play leave report added"));
},a.prototype._extend=function(e){
for(var t in e)this._o[t]=e[t];
},a.prototype._onUpdateSeekRange=function(){
var e=this,t=e._o,a=e._g;
return function(e){
this.surportSeekRange()&&t.bufferDom&&t.playdotDom?(a.canDragBar=!0,t.playdotDom.style.display="block",
t.bufferDom.style.width=1*e+"%"):(a.canDragBar=!1,t.playdotDom&&(t.playdotDom.style.display="none"));
};
},a.prototype._statusChangeCallBack=function(){
var e=this;
return function(t,a){
e._status=a,e._updatePlayerCss(this,a),e._o.musicPlayerStatusChange&&e._o.musicPlayerStatusChange(a);
};
},a.prototype._timeupdateCallBack=function(){
var e=this,t=this._o,a=this._g;
return function(o,r){
e._updateProgress(r),0!=r&&(C.reportData[t.type].play_duration2[a.posIndex]=parseInt(1e3*r));
};
},a.prototype._errorCallBack=function(){
var e=this,t=this._o,a=this._g;
return function(o,r){
C.reportData[t.type].errorcode[a.posIndex]=r.code,e._updatePlayerCss(this,3);
};
},a.prototype._reportH5Error=function(e){
if("mp.weixin.qq.com"==location.host&&1==e.type||C.debug){
var t=["code:",e.code,";type:",this._o.type,";url:",window.location.href];
this.player&&t.push(";src:"+this.player.getSrc());
var a=new Image;
a.src=["https://badjs.weixinbridge.com/badjs?level=4&id=112&msg=",encodeURIComponent(t.join("")),"&uin=",window.uin||"","&from=",this._o.type].join("");
}
},a.prototype._updatePlayerCss=function(e,t){
!!C.debug&&console.log("status:"+t);
{
var a=this._o,o=a.playCssDom;
a.progress;
}
2==t?(f.removeClass(o,a.playingCss),a.pauseCss&&f.removeClass(o,a.pauseCss),a.playdotDom&&(e.surportSeekRange()?(a.playdotDom.style.display="block",
this._g.canDragBar=!0):(a.playdotDom.style.display="none",this._g.canDragBar=!1))):3==t?(f.removeClass(o,a.playingCss),
a.pauseCss&&f.removeClass(o,a.pauseCss),a.playdotDom&&(a.playdotDom.style.display="none",
this._g.canDragBar=!1),this._updateProgress(0)):(1==t||4==t)&&(a.allowPause?f.addClass(o,a.pauseCss||a.playingCss):f.addClass(o,a.playingCss),
a.playdotDom&&(e.surportSeekRange()?(a.playdotDom.style.display="block",this._g.canDragBar=!0):(a.playdotDom.style.display="none",
this._g.canDragBar=!1))),a.loadingDom&&(a.loadingDom.style.display=4==t?"block":"none");
},a.prototype._updateProgress=function(e){
this._g.barDraging||this._updateProgressBar(e);
},a.prototype._updateProgressBar=function(e){
var t=this._o,a=this.player,o=a.getDuration();
if(o){
var r=this._countProgress(o,e);
t.progress&&(t.progress.style.width=r),t.playtimeDom&&e>=0&&(t.playtimeDom.innerHTML=d(e)),
t.playdotDom&&(t.playdotDom.style.left=r);
}
},a.prototype._countProgress=function(e,t){
return Math.min(t/e*100,100)+"%";
},a.prototype.destory=function(){
this.player&&this.player.destory();
},a.prototype.setOption=function(e){
e.duration&&(this._g.seekData.duration=e.duration),this._extend(e);
},a.prototype.setMusicPlayerOption=function(e){
e.duration&&this._g&&this._g.seekData&&(this._g.seekData.duration=e.duration),this.player&&this.player.setOption(e);
},a.prototype.getBackgroundAudioState=function(e){
return this.player.getBackgroundAudioState(e);
},{
init:c,
renderPlayer:o,
formatTime:d,
decodeStr:u,
encodeStr:_
};
});define("pages/qqmusic_tpl.html.js",[],function(){
return'<span id="qqmusic_main_<#=musicid#>_<#=posIndex#>" class="js_wap_qqmusic db pages_reset music_area <#if(!musicSupport){#> unsupport<#}#>">\n    <span class="tc tips_global unsupport_tips" <#if(show_not_support!==true){#>style="display:none;"<#}#>>\n    当前浏览器不支持播放音乐或语音，请在微信或其他浏览器中播放    </span>\n    <span class="db music_card appmsg_card_context appmsg_card_active">\n            <a id="qqmusic_home_<#=musicid#>_<#=posIndex#>" class="music_card_bd">\n                <span class="music_card_title"><#=music_name#></span>\n                <span class="music_card_desc"><#=singer#></span>\n                <span class="music_card_source <#if(musictype==2){#>music_card_source_kugou<#}#>">\n                  <img src="<#=musicIcon#>" alt=""></span>\n            </a>\n            <span id="qqmusic_play_<#=musicid#>_<#=posIndex#>" class="music_card_ft">\n                <i class="weui-play-btn"></i>\n                <!--\n                <img src="<#=window.icon_qqmusic_default#>" alt="" class="pic_qqmusic_default">\n                -->\n                <img src="<#=albumurl#>" data-autourl="<#=audiourl#>" data-musicid="<#=musicid#>" class="music_card_thumb" alt="">\n            </span>\n    </span>\n</span>\n';
});define("new_video/ctl.js",["common/comm_report.js","biz_wap/utils/ajax.js"],function(e){
"use strict";
var i,n=e("common/comm_report.js");
if(parent==window)i=window;else try{
{
parent.window.location.href;
}
i=parent.window;
}catch(r){
i=window;
}
var t=i.user_uin,a=Math.floor(i.user_uin/100)%20;
t||(a=-1);
var o=function(){
return a>=0;
};
i.__webviewid||(i.__webviewid=+new Date+"_"+Math.ceil(1e3*Math.random()));
var d=function(){
var e=i.mid,n=i.idx,r="";
r=e&&n?e+"_"+n:"";
var a=i.__webviewid,o=[t,r,a].join("_");
return o;
},s=function(i){
if(20>a)try{
var n=i.vid||"",r={};
r.__biz=parent.window.biz||"",r.vid=n,r.clienttime=+new Date;
var t=parent.window.mid,s=parent.window.idx,p="";
p=t&&s?t+"_"+s:n,r.type="undefined"!=typeof i.type?i.type:t&&s?1:2,r.id=p,r.hit_bizuin=i.hit_bizuin||"",
r.hit_vid=i.hit_vid||"",r.webviewid=d(),r.step=i.step||0,r.orderid=i.orderid||0,
r.ad_source=i.ad_source||0,r.traceid=i.traceid||0,r.ext1=i.ext1||"",r.ext2=i.ext2||"",
r.r=Math.random(),r.devicetype=parent.window.devicetype,r.version=parent.window.clientversion,
r.is_gray=o()?1:0,r.mid=t||"",r.idx=s||"",r.url=parent.window.location.href,r.screen_num=i.screen_num||0,
r.screen_height=i.screen_height||0,r.ori_status=i.ori_status||3,r.fromid=i.fromid||0,
r.sessionid=window.sessionid||"",r.appmsg_scene=window.source||(window.cgiData?window.cgiData.scene:0)||0,
!r.appmsg_scene&&r.fromid?r.appmsg_scene=r.fromid:!r.fromid&&r.appmsg_scene&&(r.fromid=r.appmsg_scene),
r.total_range=i.total_range||0,r.current_range=i.current_range||0,r.duration=i.duration||0;
var c=e("biz_wap/utils/ajax.js");
c({
url:"/mp/ad_video_report?action=user_action",
type:"post",
data:r
});
}catch(w){}
},p=function(e){
try{
var i=e.vid||"",r={};
r.BizUin=parent.window.biz||"",r.Vid=i,r.ClientTime=+new Date;
var t=parent.window.mid,a=parent.window.idx,s="";
s=t&&a?t+"_"+a:i,r.Type="undefined"!=typeof e.type?e.type:t&&a?1:2,r.Id=s,r.HitBizUin=parseInt(e.hit_bizuin)||0,
r.HitVid=e.hit_vid||"",r.WebViewId=d(),r.Step=parseInt(e.step,10)||0,r.OrderId=(e.orderid||"").toString(),
r.AdSource=parseInt(e.ad_source,10)||0,r.TraceId=(e.traceid||"").toString(),r.Ext1=(e.ext1||"").toString(),
r.Ext2=(e.ext2||"").toString(),r.r=Math.random(),r.DeviceType=parent.window.devicetype,
r.ClientVersion=parseInt(parent.window.clientversion),r.IsGray=o()?1:0,r.msgid=parseInt(t,10)||0,
r.itemidx=parseInt(a,10)||0,r.Url=parent.window.location.href,r.ScreenNum=parseInt(e.screen_num,10)||0,
r.ScreenHeight=parseInt(e.screen_height,10)||0,r.OrStatus=parseInt(e.ori_status,10)||3,
r.Fromid=parseInt(e.fromid,10)||0,r.SessionId=(window.sessionid||"").toString(),
r.AppmsgScene=parseInt(window.source||(window.cgiData?window.cgiData.scene:0),10)||0,
!r.AppmsgScene&&r.Fromid?r.AppmsgScene=r.Fromid:!r.Fromid&&r.AppmsgScene&&(r.Fromid=r.AppmsgScene),
r.AppmsgScene=parseInt(r.AppmsgScene,10)||0,r.Fromid=parseInt(r.Fromid,10)||0,r.TotalRange=parseInt(e.total_range,10)||0,
r.CurrentRange=parseInt(e.current_range,10)||0,r.Duration=parseInt(e.duration,10)||0,
r.RemindTrafficSize=parseInt(e.remind_traffic_size,10)||0,r.TrafficReminderType=parseInt(e.traffic_reminder_type,10)||0,
n.report(12710,r);
}catch(p){}
};
return{
report:s,
getWebviewid:d,
showAd:o,
commReport:p
};
});define("biz_wap/jsapi/leaveReport.js",["biz_wap/jsapi/core.js","biz_common/utils/url/parse.js","biz_wap/utils/log.js"],function(e){
"use strict";
function t(e){
var t={};
return"undefined"!=typeof uin&&(t.uin=uin),"undefined"!=typeof key&&(t.key=key),
"undefined"!=typeof pass_ticket&&(t.pass_ticket=pass_ticket),"undefined"!=typeof wxtoken&&(t.wxtoken=wxtoken),
"undefined"!=typeof window.devicetype&&(t.devicetype=window.devicetype),"undefined"!=typeof window.clientversion&&(t.clientversion=window.clientversion),
"undefined"!=typeof appmsg_token?t.appmsg_token=appmsg_token:e.indexOf("advertisement_report")>-1&&((new Image).src=location.protocol+"//mp.weixin.qq.com/mp/jsmonitor?idkey=68064_13_1&r="+Math.random()),
t.x5=s?"1":"0",t.f="json",a.join(e,t);
}
function n(e,t){
if(e instanceof Object&&t instanceof Object)for(var n in t)Object.prototype.hasOwnProperty.call(t,n)&&(e[n]=t[n]);
}
function o(e){
"function"==typeof e?l.push(e):data instanceof Object&&u.push(e);
}
function i(e,t){
v[e]||(v[e]=[]),v[e].push(t);
}
var r=e("biz_wap/jsapi/core.js"),a=e("biz_common/utils/url/parse.js"),p=e("biz_wap/utils/log.js"),s=-1!=navigator.userAgent.indexOf("TBS/"),c={},f=!1;
try{
c=top.window.document;
}catch(d){
f=!0;
}
if(!f&&top.window.__leaveReport)return top.window.__leaveReport;
if(window.__leaveReport)return window.__leaveReport;
var l=[],u=[],v=[];
r.on("reportOnLeaveForMP",function(){
p("[leaveReport 1]"),console.log("[leaveReport 1]");
var e={};
for(var o in v){
e[o]||(e[o]={});
for(var i=0;i<v[o].length;i++){
var r=v[o][i];
"function"==typeof r?n(e[o],r()):a instanceof Object&&n(e[o],r);
}
}
p("[leaveReport getDataFunc.length "+l.length+"]"),console.log("[leaveReport getDataFunc.length "+l.length+"]");
for(var i=0;i<l.length;i++){
var a=l[i]();
a instanceof Object&&u.push(a);
}
for(var i=0;i<u.length;i++)u[i].reportUrl&&(u[i].reportUrl=t(u[i].reportUrl));
return e.data={
requestList:u
},e;
});
var w={
addReport:o,
addSpecificReport:i
};
return window.__leaveReport=w,w;
});define("biz_wap/utils/hand_up_state.js",["biz_common/dom/event.js"],function(n){
"use strict";
function e(){
if("hidden"in document)return"hidden";
for(var n=["webkit","moz","ms","o"],e=0;e<n.length;e++)return n[e]+"Hidden"in document,
n[e]+"Hidden";
return null;
}
function i(){
var n=e();
return n?document[n]:!1;
}
function t(){
return r;
}
var d=n("biz_common/dom/event.js"),o=e(),r=0,u=0;
if(o){
var m=o.replace(/[H|h]idden/,"")+"visibilitychange";
d.on(document,m,function(){
i()?u=(new Date).getTime():r+=(new Date).getTime()-u;
},!1);
}
return{
getHandUpTime:t,
isHidden:i
};
});define("biz_wap/utils/storage.js",[],function(){
"use strict";
function t(t){
if(!t)throw"require function name.";
this.key=t,this.init();
}
var e="__WXLS__",n=window.localStorage||{
getItem:function(){},
setItem:function(){},
removeItem:function(){},
key:function(){},
length:0
};
return t.getItem=function(t){
return t=e+t,n.getItem(t);
},t.setItem=function(i,r){
i=e+i;
for(var a=3;a--;)try{
n.setItem(i,r);
break;
}catch(o){
t.clear();
}
},t.clear=function(){
var t,i;
for(t=n.length-1;t>=0;t--)i=n.key(t),0==i.indexOf(e)&&n.removeItem(i);
},t.prototype={
constructor:t,
init:function(){
this.check();
},
getData:function(){
var e=t.getItem(this.key)||"{}";
try{
e=JSON.parse(e);
}catch(n){
e={};
}
return e;
},
check:function(){
var e,n,i=this.getData(),r={},a=+new Date;
for(e in i)n=i[e],+n.exp>a&&(r[e]=n);
t.setItem(this.key,JSON.stringify(r));
},
set:function(e,n,i){
var r=this.getData();
r[e]={
val:n,
exp:i||+new Date
},t.setItem(this.key,JSON.stringify(r));
},
get:function(t){
var e=this.getData();
return e=e[t],e?e.val||null:null;
},
remove:function(e){
var n=this.getData();
n[e]&&delete n[e],t.setItem(this.key,JSON.stringify(n));
}
},t;
});define("biz_common/utils/http.js",[],function(){
"use strict";
function t(){
var t=document.getElementsByTagName("html");
if(t&&1==!!t.length){
t=t[0].innerHTML;
var e=t.replace(/[\x00-\xff]/g,""),n=t.replace(/[^\x00-\xff]/g,"");
return 1*n.length+3*e.length+"<!DOCTYPE html><html></html>".length;
}
return 0;
}
return{
htmlSize:t()
};
});define("biz_common/utils/cookie.js",[],function(){
"use strict";
var e={
get:function(e){
if(""==e)return"";
var t=new RegExp(e+"=([^;]*)"),n=document.cookie.match(t);
return n&&n[1]||"";
},
set:function(e,t,n){
var o=new Date;
return o.setDate(o.getDate()+(n||1)),n=o.toGMTString(),document.cookie=e+"="+t+";expires="+n,
!0;
}
};
return e;
});define("appmsg/open_url_with_webview.js",["biz_wap/jsapi/core.js"],function(e){
"use strict";
var r=e("biz_wap/jsapi/core.js"),n=-1!=navigator.userAgent.indexOf("WindowsWechat"),i=function(e,i){
if(n)return location.href=e,!1;
i=i||{};
var o=i.sample||0;
o*=1e3;
var t=window.user_uin||0,s=0!==t&&Math.floor(t/100)%1e3<o;
return s?void r.invoke("openUrlWithExtraWebview",{
url:e,
openType:i.openType||1,
scene:i.scene||"",
bizUsername:i.user_name||""
},function(e){
e&&"openUrlWithExtraWebview:ok"===e.err_msg?i.resolve&&i.resolve():i.reject&&i.reject();
}):void(i.reject&&i.reject());
};
return i;
});define("appmsg/more_read.js",["biz_common/utils/string/html.js","biz_common/tmpl.js","biz_wap/utils/ajax.js","appmsg/more_read_tpl.html.js","biz_wap/utils/openUrl.js","biz_common/dom/event.js","biz_wap/utils/jsmonitor_report.js","common/utils.js"],function(n){
"use strict";
function i(n){
for(var i=r.getInnerHeight(),e=document.documentElement.clientWidth||window.innerWidth,t=document.body.scrollHeight||document.body.offsetHeight,s=document.body.scrollTop||document.documentElement.scrollTop,m=[],a=0;a<l.length;a++){
var w=[l[a].bizuin||window.biz||"",l[a].mid||"",l[a].idx||""].join("_");
m.push(w);
}
m=m.join("#");
var p=c[n.index].getBoundingClientRect(),h="fans_read_cnt="+l[n.index].fans_read_cnt,g={
act:n.action||0,
bizuin:window.biz||"",
msgid:window.mid||"",
idx:window.idx||"",
scene:window.source||"",
sub_scene:window.subscene||"",
get_a8_key_scene:window.ascene||"",
screen_height:i,
screen_width:e,
screen_num:Math.ceil(t/i),
action_screen_num:Math.ceil((p.top+p.height+s)/i),
start_time_ms:_,
action_time_ms:Date.now(),
more_msg:m,
a_bizuin:l[n.index].bizuin||window.biz||"",
a_msgid:l[n.index].mid||"",
a_idx:l[n.index].idx||"",
rank:n.index+1,
tip:h,
session_id:u
};
o({
url:"/mp/appmsgreport?action=more_read",
type:"POST",
data:g,
timeout:2e3,
async:!1,
mayAbort:!0
});
var b=1===n.action?4:5;
d.setSum(110809,b,1);
}
function e(){
if(l){
for(var n=0,t=r.getInnerHeight(),o=0;o<c.length;o++)if(c[o].dataset.show)n++;else{
var s=c[o].getBoundingClientRect();
s.top+s.height<t&&(c[o].dataset.show=1,i({
action:1,
index:o
}));
}
n>=c.length&&a.off(window,"scroll",e);
}
}
n("biz_common/utils/string/html.js");
var t=n("biz_common/tmpl.js"),o=n("biz_wap/utils/ajax.js"),s=n("appmsg/more_read_tpl.html.js"),m=n("biz_wap/utils/openUrl.js"),a=n("biz_common/dom/event.js"),d=n("biz_wap/utils/jsmonitor_report.js"),r=n("common/utils.js"),l=null,c=null,_=Date.now(),u=""+_+"_"+Math.random().toString(36).substring(2);
return a.on(window,"scroll",e),function(n,e){
l=e,n.innerHTML=t.tmpl(s,{
list:l
}),c=n.getElementsByClassName("more_read_link");
for(var o=0;o<c.length;o++)a.on(c[o],"click",function(n){
return function(){
window.__second_open__?m.openUrlWithExtraWebview(l[n].link.htmlDecode()):window.location.href=l[n].link.htmlDecode(),
i({
action:2,
index:n
});
};
}(o));
n.style.display="";
};
});var _extends=Object.assign||function(e){
for(var t=1;t<arguments.length;t++){
var n=arguments[t];
for(var o in n)Object.prototype.hasOwnProperty.call(n,o)&&(e[o]=n[o]);
}
return e;
};
define("appmsg/comment.js",["biz_common/utils/string/html.js","biz_common/dom/class.js","appmsg/cmt_tpl.html.js","biz_common/utils/wxgspeedsdk.js","appmsg/comment_report.js","biz_wap/utils/device.js","appmsg/retry_ajax.js","biz_common/dom/offset.js","biz_common/utils/url/parse.js","biz_wap/jsapi/core.js","common/utils.js","appmsg/emotion/selection.js","appmsg/i18n.js","biz_common/dom/event.js","biz_wap/utils/ajax.js","biz_common/tmpl.js","biz_wap/utils/fakehash.js","appmsg/log.js","appmsg/my_comment_tpl.html.js","appmsg/emotion/dom.js","pages/utils.js","biz_wap/utils/mmversion.js","common/comm_report.js","biz_wap/utils/position.js","appmsg/set_font_size.js","common/color/background_color.js","biz_wap/utils/jsmonitor_report.js","appmsg/emotion/emotion_pc.js","appmsg/emotion/emotion.js","appmsg/comment_tpl.html.js","appmsg/comment_pc_tpl.html.js","appmsg/friend_comment_tpl.html.js"],function(e,t,n,o){
"use strict";
function i(e){
var t=document.getElementById(e);
t.parentNode.removeChild(t);
}
function m(e,t){
e&&(e.style.display=t||"block");
}
function d(e){
e&&(e.style.display="none");
}
function s(){
At.mylist.children.length?(m(At.mylist.parentNode),Jt||G.removeClass(document.body,Zt)):(d(At.mylist.parentNode),
Jt||G.addClass(document.body,Zt));
}
function a(e){
At.el_alertContent.innerHTML=e,At.el_alertPanel.style.display="";
}
function l(){
Jt?(G.removeClass(document.getElementById("js_success_panel_pc"),"weui-transition_opacity-hide"),
setTimeout(function(){
G.addClass(document.getElementById("js_success_panel_pc"),"weui-transition_opacity-hide");
},750)):(setTimeout(function(){
m(At.toast);
},750),setTimeout(function(){
d(At.toast);
},1500));
}
function c(e){
return e.toString().replace(/^\s+|\s+$/g,"");
}
function r(e,t){
if(!(Math.random()<.999)){
var n=9;
"https:"===window.location.protocol&&(n=18),V.saveSpeeds({
uin:window.uin,
pid:n,
speeds:[{
sid:29,
time:e
},{
sid:30,
time:t
}]
}),V.send();
}
}
function _(e){
var t=arguments.length<=1||void 0===arguments[1]?"":arguments[1];
if("undefined"!=typeof e)if(vt.idkey)ft.setSum(vt.idkey,e,1);else{
var n=new Image,o=Math.random();
n.src="/mp/jsreport?key="+e+"&content="+t+"&r="+o;
}
}
function p(){
kt||(kt=!0,new Q({
comment_id:xt,
appmsgid:window.appmsgid,
idx:window.idx,
item_show_type:window.item_show_type||0,
biz:window.biz
}));
}
function u(){
try{
var e=At.loading.getBoundingClientRect(),t=Math.random()<1;
e.top<et.getInnerHeight()&&Lt&&t&&(ft.setLogs({
id:28307,
key:45,
value:1,
lc:1,
log0:""
}),ot.off(window,"scroll",u));
}catch(n){
console.error(n);
}
}
function g(){
var e=At.showAll,t=et.getScrollTop(),n=pt.getY(e,"js_article");
return 0===e.clientHeight?!1:(e.clientHeight+n>=t+e.clientHeight/2&&e.clientHeight+n<=t+e.clientHeight/2+et.getInnerHeight()&&(_t.report(18832,_extends({
Actiontype:1,
Type:3,
Bizuin:0,
Msgid:0,
Itemidx:0,
Sendtimestamp:0,
Pos:0
},yt)),ft.setSum(110809,26,1),ot.off(window,"scroll",g)),!0);
}
function f(e){
var t=(new Date).getTime(),n=new Date;
n.setDate(n.getDate()+1),n.setHours(0),n.setMinutes(0),n.setSeconds(0),n=n.getTime();
var o=t/1e3-e,i=n/1e3-e,m=new Date(n).getFullYear(),d=new Date(1e3*e);
return 3600>o?Math.ceil(o/60)+"分钟前":86400>i?Math.floor(o/60/60)+"小时前":172800>i?"昨天":604800>i?Math.floor(i/24/60/60)+"天前":d.getFullYear()===m?d.getMonth()+1+"月"+d.getDate()+"日":d.getFullYear()+"年"+(d.getMonth()+1)+"月"+d.getDate()+"日";
}
function w(e){
lt.each(e.querySelectorAll("div.discuss_message_content"),function(e){
e.innerHTML=on.encode(e.innerHTML);
});
}
function y(e,t,n){
var o=void 0,i=void 0,m="",d="",s=document.createElement("div");
"elected"===n?d=0:"friend"===n&&(d=1),Ut={};
for(var a=0;a<e.length;a++){
if(i=e[a],i.time=f(i.create_time),i.status="",i.logo_url=i.logo_url||mn,i.logo_url=-1!==i.logo_url.indexOf("wx.qlogo.cn")?i.logo_url.replace(/\/132$/,"/96"):i.logo_url,
i.content=i.content.htmlDecodeLite().htmlEncodeLite(),i.nick_name=i.nick_name.htmlDecodeLite().htmlEncodeLite(),
i.like_num_format=parseInt(i.like_num,10)>=1e4?(i.like_num/1e4).toFixed(1)+"万":i.like_num,
"en"===window.LANG&&(i.like_num_format=nt.dealLikeReadShow_en(i.like_num)),i.is_from_friend="friend"===n?0:i.is_from_friend||0,
i.is_from_me="mine"===n?1:i.is_from_me||0,i.reply=i.reply||{
reply_list:[]
},i.is_mine=!n,i.is_elected="elected"===n||"friend"===n?1:i.is_elected,i.is_top="friend"===n?0:i.is_top,
i.report_elected=i.is_elected||0,i.report_friend=i.is_from_friend||0,i.scene=d,i.reply.reply_list.length>0){
var l=i.reply.reply_list[0];
l.time=f(l.create_time),l.content=(l.content||"").htmlEncodeLite(),l.reply_like_status=l.reply_like_status||0,
l.reply_like_num=l.reply_like_num||0,l.reply_like_num_format=parseInt(l.reply_like_num,10)>=1e4?(l.reply_like_num/1e4).toFixed(1)+"万":l.reply_like_num,
"en"===window.LANG&&(l.reply_like_num_format=nt.dealLikeReadShow_en(l.reply_like_num));
}
i.new_appmsg=window.new_appmsg,m+=mt.tmpl(Y,i);
try{
var c=i.nick_name+i.content,r=!1,p=vt.repeatContentID;
Ut[c]&&(r=!0,p=vt.repeatContent),Rt.indexOf(i.content_id)>-1&&(r=!0,p=vt.repeatContentID),
Rt.push(i.content_id),Ut[c]=!0,r&&_(p,encodeURIComponent(JSON.stringify({
comment_id:xt,
content_id:i.content_id,
offset:St,
length:e.length,
url:Qt
})));
}catch(u){
console.error(u);
}
}
for(s.innerHTML=m,w(s);s.children.item(0);)o=s.children.item(0),t.appendChild(o);
}
function h(e){
var t=void 0,n=void 0,o=Date.now(),i=e.resp,s=e.loadTime,a=e.forceRefresh,l=document.createDocumentFragment(),c=document.createDocumentFragment();
if(Et=i.only_fans_can_comment,_(vt.handleList,encodeURIComponent(JSON.stringify({
comment_id:xt,
offset:St,
url:Qt
}))),1!==i.enabled?(Kt&&(Kt.style.display="none"),en&&d(en),i.elected_comment=[],
i.friend_comment=[],i.elected_comment_total_cnt=0,i.friend_comment_total_cnt=0):(Kt&&(Kt.style.display="block"),
en&&m(en)),0===St){
if(Mt=i.logo_url,Ft=i.nick_name,a&&(Rt=[]),t=i.elected_comment,t&&t.length){
if(y(t,l,"elected"),a&&(At.list.innerHTML=""),At.list.appendChild(l),m(At.main),
Gt&&0===Yt?(document.getElementById("js_cmt_nofans1").innerHTML="作者已设置关注3天后才可留言",
m(document.getElementById("js_cmt_nofans1"),"block")):Et&&0===i.is_fans?(document.getElementById("js_cmt_nofans1").innerHTML="作者已设置关注后才可以留言",
m(document.getElementById("js_cmt_nofans1"),"block")):wt&&(Jt?(m(At.commentPC),m(At.inputPC)):m(At.addCmtBtn1)),
i.elected_comment_total_cnt<=10&&(m(document.getElementById("js_cmt_statement")),
m(document.getElementById("js_cmt_qa"))),!Tt&&"5"===window.item_show_type){
var u=Date.now()-window.logs.pagetime.page_begin;
Tt=!0,Math.random()<.1&&(V.saveSpeeds({
uin:window.uin,
pid:675,
speeds:[{
sid:27,
time:u
}]
}),V.send());
}
}else d(At.main),Gt&&0===Yt?(document.getElementById("js_cmt_nofans2_inner").innerHTML="作者已设置关注3天后才可留言",
m(document.getElementById("js_cmt_nofans2"),"block")):Et&&0===i.is_fans?(document.getElementById("js_cmt_nofans2_inner").innerHTML="作者已设置关注后才可以留言",
m(document.getElementById("js_cmt_nofans2"),"block")):wt&&(Jt?(m(At.commentPC),m(At.inputPC)):m(At.addCmtBtn2));
n=i.friend_comment,y(n,c,"friend"),n&&0===n.length&&d(en),a&&(At.fdlist.innerHTML=""),
At.fdlist&&At.fdlist.appendChild(c),n&&n.length?(m(At.fdmain),(!Et||Et&&1===i.is_fans)&&(Jt||(d(At.addCmtBtn1),
d(At.addCmtBtn2),wt&&m(At.addCmtBtn3)))):d(At.fdmain);
var g=document.getElementById("js_cmt_area");
location.href.indexOf("scrolltodown")>-1&&g&&g.offsetTop&&window.scrollTo(0,g.offsetTop-25);
}else t=i.elected_comment,t&&t.length&&(y(t,l,"elected"),At.list.appendChild(l));
0===i.elected_comment_total_cnt?(St=-1,d(document.getElementById("js_cmt_loading")),
d(document.getElementById("js_cmt_statement")),d(document.getElementById("js_cmt_qa"))):St+Vt>=i.elected_comment_total_cnt?(St=-1,
d(document.getElementById("js_cmt_loading")),m(document.getElementById("js_cmt_statement")),
m(document.getElementById("js_cmt_qa"))):St+=i.elected_comment.length,window.ipados13_font_scale&&ut.setFontSize(At.main,window.ipados13_font_scale/100);
var f=5;
if(window.user_uin%2===0&&(f=8),t.length>f&&window.has_related_article){
var w=0;
m(At.showAll),d(document.getElementById("js_cmt_statement"));
for(var h=At.list.querySelectorAll("li.js_comment_item"),j=0;f>j;j++){
var C=window.getComputedStyle(h[j]);
w+=h[j].getBoundingClientRect().height+parseFloat(C.paddingTop)+parseFloat(C.paddingBottom)+parseFloat(C.borderTopWidth)+parseFloat(C.borderBottomWidth)+parseFloat(C.marginTop)+parseFloat(C.marginBottom);
}
At.listContainer.style.height=w+"px",At.showAllWording.innerText="查看更多%s条留言".replace("%s",t.length-f);
var v=function(){
if("none"!==At.showAll.style.display){
for(var e=0,t=At.list.querySelectorAll("li.js_comment_item"),n=0;f>n;n++){
var o=window.getComputedStyle(t[n]);
e+=t[n].getBoundingClientRect().height+parseFloat(o.paddingTop)+parseFloat(o.paddingBottom)+parseFloat(o.borderTopWidth)+parseFloat(o.borderBottomWidth)+parseFloat(o.marginTop)+parseFloat(o.marginBottom);
}
At.listContainer.style.height=e+"px";
}
};
window.addEventListener("resize",v),window.ipados13_font_scale&&(ut.setFontSize(At.showAllWording,window.ipados13_font_scale/100),
ut.onFontScaleChange(v)),ft.setSum(110809,25,1);
}
p(),ct.setTwoTabHeight("js_comment_content"),s&&r(s,Date.now()-o);
}
function j(e){
if(xt=window.comment_id,0!==Number(xt)){
var t=e.forceRefresh,n=e.cb;
t=t===!0,t&&(St=0);
var o=et.getScrollTop(),i=document.documentElement.scrollHeight;
if(!(Lt||-1===St||St>0&&i-o-et.getInnerHeight()>500)){
if("number"==typeof Bt&&0===Bt&&!t)return void h({
resp:{
enabled:1,
elected_comment:[],
friend_comment:[],
elected_comment_total_cnt:0,
my_comment:[],
only_fans_can_comment:Et,
is_fans:bt,
logo_url:Mt,
nick_name:Ft
}
});
var s=$.join("/mp/appmsg_comment",{
action:"getcomment",
scene:vt.scene,
appmsgid:window.appmsgid,
idx:window.idx,
comment_id:xt,
offset:St,
limit:Vt,
send_time:window.send_time
},!0),a=+new Date;
Lt=!0,d(At.tips),m(At.loading);
try{
zt++,t&&(Dt=[]),zt>1&&!t&&_(vt.moreList,encodeURIComponent(s)),Dt.indexOf(s)>-1&&_(vt.repeatList,encodeURIComponent(s)),
Dt.push(s);
}catch(l){
console.error(l);
}
nn&&console.info("[图文评论] 开始请求评论数据:",s),st("[Appmsg comment] start get comment data, url:"+s),
it({
url:s,
dataType:"json",
success:function(e){
var o=e.base_resp&&e.base_resp.ret;
0===o?n&&n({
resp:e,
forceRefresh:t,
loadTime:Date.now()-a
}):_(vt.errList,"type:resperr;url:"+encodeURIComponent(s)+";ret="+o),st("[Appmsg comment] get comment success");
},
error:function(){
_(vt.errList,"type:ajaxerr;url:"+encodeURIComponent(s)),st("[Appmsg comment] get comment ajax error");
},
complete:function(){
Lt=!1,d(At.loading),ot.off(window,"scroll",u);
}
});
}
}
}
function C(){
At.list.children.length?At.fdlist.children.length?(wt&&m(At.addCmtBtn3),d(At.addCmtBtn1),
d(At.addCmtBtn2),d(At.addCmtBtn4)):(wt&&m(At.addCmtBtn1),d(At.addCmtBtn2),d(At.addCmtBtn3),
d(At.addCmtBtn4)):At.fdlist.children.length?(wt&&m(At.addCmtBtn3),d(At.addCmtBtn4),
d(At.addCmtBtn1),d(At.addCmtBtn2)):(wt&&m(At.addCmtBtn2),d(At.addCmtBtn3),d(At.addCmtBtn1),
d(At.addCmtBtn4)),Jt&&(d(At.addCmtBtn1),d(At.addCmtBtn2),d(At.addCmtBtn3));
}
function v(e,t){
var n=document.createDocumentFragment();
l(),y([{
content:t,
nick_name:Ft,
create_time:Date.now()/1e3|0,
is_elected:0,
logo_url:Mt,
like_status:0,
like_num_format:0,
like_num:0,
is_from_friend:0,
is_from_me:1,
my_id:e.my_id,
content_id:e.content_id
}],n,"mine"),At.mylist.insertBefore(n,At.mylist.firstChild),s(),Jt?(At.input.innerHTML="",
At.inputHolder.style.display=""):At.input.value="",C();
}
function b(){
lt.log("tag1");
var e=void 0,t=$.join("/mp/appmsg_comment",{
action:"addcomment",
scene:vt.scene,
appmsgid:window.appmsgid,
idx:window.idx,
comment_id:xt,
sn:window.sn
},!0);
if(e=Jt?c(Nt).replace(/<br\/>/g,"").replace(/\n/g,"")||"":c(At.input.value),lt.log("tag2"),
!G.hasClass(At.submit,"btn_disabled")&&At.submit.disabled!==!0){
if(lt.log("tag3"),e.length<1)return void a("留言不能为空");
if(lt.log("tag4"),e.length>600)return void a("字数不能多于600个");
Jt&&(e=Nt),lt.log("tag5"),Jt?At.submit.disabled=!0:G.addClass(At.submit,"btn_disabled"),
lt.log("tag6");
var n=document.getElementById("activity-name");
lt.log("tag7"),It!==e&&(qt=Date.now()),it({
url:t,
data:{
content:e,
title:n&&c(n.innerText),
head_img:Mt,
nickname:Ft,
client_id:qt
},
type:"POST",
dataType:"json",
success:function(n){
switch(lt.log("tag8"),Jt||on.hidePannel(),+n.ret){
case 0:
v(n,e);
break;

case-6:
a("你留言的太频繁了，休息一下吧");
break;

case-7:
a("你还未关注该公众号，不能参与留言");
break;

case-10:
a("字数不能多于600个");
break;

case-15:
a("留言已关闭");
break;

default:
It=e,a("系统错误，请重试");
}
0!==Number(n.ret)&&_(vt.addCommentErr,"type:resperr;url:"+encodeURIComponent(t)+";ret="+n.ret);
},
error:function(e){
lt.log("shit;"+e.status+";"+e.statusText),_(vt.addCommentErr,"type:ajaxerr;url:"+encodeURIComponent(t));
},
complete:function(){
""!==At.input.value&&G.removeClass(At.submit,"btn_disabled");
}
});
}
}
function B(e){
return e.filter(function(e){
return!e.is_elected&&1!==e.is_elected;
});
}
function I(){
var e=document.getElementById("js_mycmt_loading"),t=$.join("/mp/appmsg_comment",{
action:"getmycomment",
scene:vt.scene,
appmsgid:window.appmsgid,
idx:window.idx,
comment_id:xt
},!0);
s(),0===Ot&&(Ot=1,m(e),it({
url:t,
dataType:"json",
success:function(e){
var n=e.base_resp&&e.base_resp.ret;
if(0===n){
var o=e.my_comment,i=document.createDocumentFragment();
o&&o.length&&(Jt&&(m(At.myareaPC),m(At.mylist),o=B(o)),y(o,i,"mine"),At.mylist.appendChild(i)),
Ot=2;
}else Ot=0,_(vt.errComment,"type:resperr;url:"+encodeURIComponent(t)+";ret="+n);
},
error:function(){
Ot=0,_(vt.errComment,"type:ajaxerr;url:"+encodeURIComponent(t));
},
complete:function(){
d(e),s();
}
}));
}
function k(e){
Pt=et.getScrollTop(),d(At.article),m(At.mine),At.deletePanel=document.getElementById("js_delete_panel_mobile"),
At.deleteConfirm=document.getElementById("js_delete_confirm_mobile"),At.deleteCancel=document.getElementById("js_delete_cancel_mobile"),
window.__second_open__&&J.os.ios&&m(At.fakebar),window.scrollTo(0,0),I(),e||lt.later(function(){
At.input.focus();
});
}
function E(){
"1"===$.getQuery("js_my_comment")&&k(!0);
}
function T(){
return rt.isWechat?J.os.ipad?!1:rt.isInMiniProgram?!1:rt.isIOS&&rt.gtVersion("7.0.8")?!0:rt.isAndroid&&rt.gtVersion("7.0.8")?!0:et.isNativePage()&&(rt.isIOS||rt.isAndroid)?!0:!1:!1;
}
function x(){
var e=document.getElementById("activity-name");
return T()?(K.invoke("handleMPPageAction",{
action:"writeComment",
title:e&&c(e.innerText),
comment_id:xt,
style:an?"black":"white"
}),!0):!1;
}
function S(){
d(At.mine),m(At.article),At.deletePanel=document.getElementById("js_delete_panel"),
At.deleteConfirm=document.getElementById("js_delete_confirm"),At.deleteCancel=document.getElementById("js_delete_cancel"),
window.scrollTo(0,Pt),At.input.blur(),G.removeClass(document.body,Xt),G.removeClass(document.body,Zt),
et.isNativePage()||sn(an||Wt?"#232323":"#ffffff");
}
function P(e){
var t=G.hasClass(e,"praised"),n=e.querySelector(".praise_num"),o=parseInt(n.getAttribute("data-num")||0,10),i=n.getAttribute("data-like");
t===("1"===i)&&(t?o--:o++),"en"===window.LANG?n.innerHTML=nt.dealLikeReadShow_en(o):-1===n.innerHTML.indexOf("万")&&(n.innerHTML=o),
t?(G.removeClass(e,"praised"),e.dataset.status=0):(G.addClass(e,"praised"),e.dataset.status=1);
}
function L(e){
var t=e.delegatedTarget||e.srcElement,n=null;
if(G.hasClass(t,"js_comment_praise")&&(n=t),n){
for(var o=parseInt(n.dataset.status,10),i=0===o?1:0,m=n.dataset.contentId,d=n.dataset.scene,s=document.querySelectorAll('.js_comment_praise[data-content-id="'+m+'"]'),a=0;a<s.length;a++)P(s[a]);
X({
url:"/mp/appmsg_comment?action=likecomment",
type:"POST",
data:{
like:i,
appmsgid:window.appmsgid,
comment_id:xt,
content_id:m,
item_show_type:window.item_show_type||0,
scene:d
}
});
}
}
function M(e){
for(var t=e.delegatedTarget,n=parseInt(t.dataset.status,10),o=n?0:1,i=t.dataset.contentId,m=t.dataset.replyId,d=t.dataset.scene,s=document.querySelectorAll('.js_reply_praise[data-content-id="'+i+'"]'),a=0;a<s.length;a++)P(s[a]);
it({
url:"/mp/appmsg_comment?action=like_author_reply",
type:"post",
data:{
comment_id:xt,
content_id:i,
reply_id:m,
like:o,
scene:d,
item_show_type:window.item_show_type||0
}
});
}
function H(e,t){
e.parentNode.removeChild(e),G.addClass(At.deletePanel,"weui-transition_opacity-hide");
for(var n=document.querySelectorAll(".cid"+t),o=0;o<n.length;o++)n[o].parentNode.removeChild(n[o]);
At.list.children.length?At.fdlist.children.length||d(At.fdmain):(d(At.main),d(document.getElementById("js_cmt_statement")),
d(document.getElementById("js_cmt_qa")),At.fdlist.children.length||d(At.fdmain)),
s(),C();
}
function z(e){
var t=void 0,n=e.delegatedTarget,i=n.getAttribute("data-my-id"),m=$.join("/mp/appmsg_comment",{
action:"delete",
scene:vt.scene,
appmsgid:window.appmsgid,
my_id:i,
comment_id:xt
},!0);
G.removeClass(At.deletePanel,"weui-transition_opacity-hide"),ot.on(At.deleteConfirm,"click",function(){
t!==i&&(t=i,it({
url:m,
dataType:"json",
success:function(e){
var t=n;
if(0===e.ret){
for(;t&&(t.nodeType!==t.ELEMENT_NODE||"li"!==t.tagName.toLowerCase());)t=t.parentNode;
t&&H(t,i);
}else o("删除失败，请重试");
},
error:function(){
o("网络错误，请重试");
}
}));
}),ot.on(At.deleteCancel,"click",function(){
t!==i&&(t=i,G.addClass(At.deletePanel,"weui-transition_opacity-hide"));
});
}
function D(e){
e&&e.preventDefault(),S(),d(At.fakebar);
}
function A(e,t){
return x()?void _t.report(19048,_extends({
EventType:1,
IsFans:bt,
CommentPageType:2
},Ct)):(et.isNativePage()||(G.addClass(document.body,Xt),sn("5"===window.item_show_type||Wt?"#191919":"#ffffff")),
t?(nn&&console.log("FakeHash on comment"),void k()):(e.preventDefault(),window.__second_open__&&J.os.ios?k():(nn&&console.log("push comment"),
dt.push("comment")),void _t.report(19048,_extends({
EventType:1,
IsFans:bt,
CommentPageType:1
},Ct))));
}
function R(e){
window.scrollTo(0,window.scrollY+e.getBoundingClientRect().height);
}
function N(e){
return e.getBoundingClientRect().top+e.getBoundingClientRect().height>=et.getInnerHeight()?!0:!1;
}
function F(){
dt.on("comment",function(){
A(null,!0);
}),dt.on("article",function(){
nn&&console.log("FakeHash on article"),S();
}),dt.on(function(e){
"comment"===e&&S();
});
}
function O(){
ot.on(At.input,"input",function(e){
if(Jt){
var t=At.input.innerHTML;
""===t||"<br>"===t?(At.inputHolder.style.display="",At.input.innerHTML=""):At.inputHolder.style.display="none";
}
var n=c(At.input.value||At.input.innerHTML);
n.length<1?G.addClass(At.submit,"btn_disabled"):G.removeClass(At.submit,"btn_disabled"),
J.os.ios&&e.data&&dn.indexOf(e.data)>-1&&(Ht=!0);
}),ot.on(At.input,"click",function(){
J.os.ios&&Ht&&(At.input.blur(),At.input.focus(),Ht=!1);
}),ot.on(At.el_alertConfirm,"click",function(){
At.el_alertPanel.style.display="none";
}),Jt&&ot.on(At.input,"click",function(){
d(document.getElementById("js_emotion_panel_pc"));
}),ot.on(At.list,"click",".js_comment_praise",L),ot.on(At.mylist,"click",".js_comment_praise",L),
ot.on(At.fdlist,"click",".js_comment_praise",L),ot.on(At.list,"click",".js_reply_praise",M),
ot.on(At.fdlist,"click",".js_reply_praise",M),ot.on(At.list,"click",".js_del",z),
ot.on(At.mylist,"click",".js_del",z),ot.on(At.fdlist,"click",".js_del",z),et.listenMpPageAction(function(e){
if("deleteComment"===e.action&&H(document.getElementById("cid"+e.personal_comment_id),e.personal_comment_id),
"praiseComment"===e.action){
console.log("praiseComment",e.personal_comment_id,e.reply_id,e.is_like);
var t=[];
e.reply_id&&0!==e.reply_id?(t=document.querySelectorAll('.js_reply_praise[data-my-id="'+e.personal_comment_id+'"][data-reply-id="'+e.reply_id+'"]'),
console.log(t)):t=document.querySelectorAll('.js_comment_praise[data-my-id="'+e.personal_comment_id+'"]');
var n=!0,o=!1,i=void 0;
try{
for(var m,d=t[Symbol.iterator]();!(n=(m=d.next()).done);n=!0){
var s=m.value;
G.hasClass(s,"praised")===!e.is_like&&P(s);
}
}catch(a){
o=!0,i=a;
}finally{
try{
!n&&d.return&&d.return();
}finally{
if(o)throw i;
}
}
}
}),ot.on(At.list,"click",".js_del",function(e){
e.preventDefault();
}),ot.on(At.mylist,"click",".js_del",function(e){
e.preventDefault();
}),ot.on(At.fdlist,"click",".js_del",function(e){
e.preventDefault();
}),ot.on(At.submit,"click",b),ot.on(At.submit,"click",function(e){
e.preventDefault();
}),At.goback&&(ot.on(At.goback,"click",D),ot.on(At.goback,"click",D)),window.__second_open__&&J.os.ios&&!function(){
ot.on(At.input,"click",function(){
d(At.fakebar);
}),ot.on(At.input,"blur",function(){
"none"!==At.mine.style.display&&m(At.fakebar);
});
var e=null,t=null;
ot.on(window,"orientationchange",function(){
"none"!==At.fakebar.style.display&&(clearTimeout(e),e=setTimeout(function(){
window.innerWidth!==parseFloat(getComputedStyle(At.fakebar).width)&&(clearTimeout(t),
At.mine.style.height=et.getInnerHeight()+"px",window.scrollBy&&window.scrollBy(0,1),
t=setTimeout(function(){
window.scrollBy&&window.scrollBy(0,-1),At.mine.style.height="";
},100));
},50));
});
}(),ot.on(window,"scroll",u),window.hasRelatedArticleInfo&&ot.on(window,"scroll",g),
ot.on(document.getElementById("js_cmt_write1"),"click",function(e){
A(e);
}),ot.on(document.getElementById("js_cmt_write2"),"click",function(e){
A(e);
}),ot.on(document.getElementById("js_cmt_write3"),"click",function(e){
A(e);
}),ot.on(document.getElementById("js_cmt_write4"),"click",function(e){
A(e);
}),ot.on(At.inputPC,"click",function(){
d(At.inputPC),m(At.containerPC),N(At.containerPC)&&R(At.containerPC),At.input.focus();
}),ot.bindVisibilityChangeEvt(function(e){
e&&et.getScrollTop()<Z.getOffset(At.cmtContainer).offsetTop-et.getInnerHeight()&&j({
forceRefresh:!0,
cb:h
});
}),ot.on(At.showAllWording,"tap",function(e){
e.preventDefault(),d(At.showAll),m(document.getElementById("js_cmt_statement")),
At.listContainer.style.height="auto",_t.report(18832,_extends({
Actiontype:2,
Type:3,
Bizuin:0,
Msgid:0,
Itemidx:0,
Sendtimestamp:0,
Pos:0
},yt)),ft.setSum(110809,27,1);
});
}
function U(){
function e(){
var e=document.createElement("div"),t="";
e.innerHTML=At.input.innerHTML;
for(var n=e.childNodes.length-1;n>=0;n--){
var o=e.childNodes[n];
switch(o.nodeType){
case 1:
if("BR"!==o.nodeName.toUpperCase()){
var i=void 0,m=!1;
if(i="IMG"===o.nodeName.toUpperCase()?o:"",i||(i=o.textContent||o.innerText||"",
m=!0),i){
var d=m?document.createTextNode(i):i;
e.replaceChild(d,o);
}else e.removeChild(o);
}
break;

case 3:
break;

default:
e.removeChild(o);
}
}
return t=e.innerHTML;
}
function t(){
g=tt.getRange();
}
function n(){
if(g){
var e=tt.getSelection();
if(e.addRange)e.removeAllRanges(),e.addRange(g);else{
var t=tt.getRange();
t.setEndPoint&&(t.setEndPoint("EndToEnd",g),t.setEndPoint("StartToStart",g)),t.select();
}
}
}
function o(){
At.input.focus(),At.input.scrollTop=At.input.scrollHeight,n();
}
function i(){
var e=c(Nt).replace(/<br\/>/g,"").replace(/\n/g,"").length;
y.innerText=e,e>600?(w.style.display="",G.addClass(w,"comment_primary_counter_warn"),
At.submit.disabled=!0):1>e?(w.style.display="none",G.removeClass(w,"comment_primary_counter_warn"),
At.submit.disabled=!0):(w.style.display="none",G.removeClass(w,"comment_primary_counter_warn"),
At.submit.disabled=!1);
}
function s(e,t){
var n=["&#96;","`","&#39;","'","&quot;",'"',"&nbsp;"," ","&gt;",">","&lt;","<","&yen;","¥","&amp;","&"],o=["&","&amp;","¥","&yen;","<","&lt;",">","&gt;"," ","&nbsp;",'"',"&quot;","'","&#39;","`","&#96;"],i=void 0;
i=t?o:n;
for(var m=0;m<i.length;m+=2)e=e.replace(new RegExp(i[m],"g"),i[m+1]);
return e;
}
function a(){
document.execCommand("AutoUrlDetect",!1,!1);
var t=e();
t=s(t),Nt=on.textFilter(t),i();
}
function l(e){
o();
var n=tt.getRange();
if(n){
if(n.createContextualFragment){
e+='<img style="width:1px;height:1px;"></img>';
var i=n.createContextualFragment(e),m=i.lastChild,d=tt.getSelection();
n.deleteContents(),n.insertNode(i),n.setStartBefore(m),n.setEndAfter(m),d.removeAllRanges(),
d.addRange(n),document.execCommand("Delete",!1,null);
}else n.pasteHTML&&e&&(n.pasteHTML(e),n.select(),n.collapse&&n.collapse(!1));
t(),a();
}
}
function r(e){
var t=e.currentTarget,n=t.getAttribute("data-index"),o=f[n].name,i='<img src="/mpres/zh_CN/htmledition/comm_htmledition/images/pic/common/pic_blank.gif"\n      class="icon_emotion_single '+o+'" alt="mo-'+f[n].title+'"></img>';
l(i),on.emotionPanelMove();
}
function _(){
for(var e=At.input,t=void 0,n=e.childNodes.length-1;n>=0;n--){
var o=e.childNodes[n];
switch(o.nodeType){
case 1:
if("BR"!==o.nodeName.toUpperCase()){
var i=void 0,m=!1;
if(i="IMG"===o.nodeName.toUpperCase()?o:"",i||(i=o.textContent||o.innerText||"",
m=!0),i){
var d=m?document.createTextNode(i):i;
t||(t=d),e.replaceChild(d,o);
}else e.removeChild(o);
}
break;

case 3:
break;

default:
e.removeChild(o);
}
}
tt.setCursorToEnd(t);
}
function p(e,t){
for(;void 0!==e&&null!==e&&null!==e.tagName&&"BODY"!==e.tagName.toUpperCase();){
if(e===t)return!0;
e=e.parentNode;
}
return!1;
}
var u=void 0,g=tt.getRange(),f=on.edata,w=document.getElementById("js_length_notice_pc"),y=document.getElementById("js_word_length_pc");
J.os.Mac&&(window.onblur=function(){
At.input&&"none"!==At.input.display&&""!==At.input.innerHTML&&At.input.blur();
}),ot.on(At.input,"keyup",function(){
t(),a();
}),ot.on(At.input,"keydown",function(e){
return 13===e.keyCode?(l("<br/>"),t(),!1):void 0;
}),ot.on(At.input,"mouseup",function(){
t(),a();
}),ot.on(At.input,"paste",function(){
u&&clearTimeout(u),u=setTimeout(function(){
return _(),t(),a(),!1;
},10);
}),ot.on(document,"click",function(e){
var t=e.srcElement||e.delegatedTarget,n=document.getElementById("js_emotion_panel_pc");
if(!p(t,At.addbtnPC)&&"none"!==At.containerPC.style.display){
var o=At.input.innerHTML;
""===c(o)&&(d(At.containerPC),m(At.inputPC),d(n));
}
p(t,n)||p(t,At.emotionSwitchPC)||"none"===n.style.display||d(n);
},!1),lt("li.js_emotion_item").on("click",r);
}
function q(t){
if(Et=t.only_fans_can_comment,Ft=t.nick_name,bt=t.is_fans,Mt=t.logo_url,Bt=t.comment_count,
Gt=t.only_fans_days_can_comment,Yt=t.is_fans_days,window._has_comment=!0,!$t||0===Number(xt))return void(window._has_comment=!1);
if(Kt){
var n=e("appmsg/comment_tpl.html.js"),o=e("appmsg/comment_pc_tpl.html.js");
Kt.innerHTML=mt.tmpl(n,{
new_appmsg:window.new_appmsg
}),tn.insertAdjacentHTML("afterbegin",mt.tmpl(o,{
new_appmsg:window.new_appmsg
}));
}
if(en){
var m=e("appmsg/friend_comment_tpl.html.js");
en.innerHTML=mt.tmpl(m,{
new_appmsg:window.new_appmsg
});
}
var d="";
1*window.item_show_type===10&&(d=document.getElementById("js_text_content").innerHTML.replace(/<(\/?)(?=((a(\s|>))|(\/a))).*?>/g,""));
var s=document.createElement("div");
s.innerHTML=mt.tmpl(at,{
new_appmsg:window.new_appmsg,
isIos:J.os.ios,
textPageTitle:d
}),document.body.appendChild(s),Jt?(i("js_cmt_mine"),document.getElementById("js_avatar_pc").src=Mt,
G.addClass(document.body,"pages_skin_pc")):i("js_cmt_addbtn_pc"),At={
article:document.getElementById("js_article"),
mine:document.getElementById("js_cmt_mine"),
main:document.getElementById("js_cmt_main"),
input:document.getElementById("js_cmt_input"),
submit:document.getElementById("js_cmt_submit"),
goback:document.getElementById("js_cmt_goback"),
addbtn:document.getElementById("js_cmt_addbtn"),
list:document.getElementById("js_cmt_list"),
mylist:document.getElementById(Jt?"js_cmt_mylist_pc":"js_cmt_mylist"),
morelist:document.getElementById("js_cmt_morelist"),
toast:document.getElementById("js_cmt_toast"),
tips:document.getElementById("js_cmt_tips"),
loading:document.getElementById("js_cmt_loading"),
fdmain:document.getElementById("js_friend_cmt_main"),
fdlist:document.getElementById("js_friend_cmt_list"),
fdlisthide:document.getElementById("js_friend_cmt_list_hide"),
morefdlist:document.getElementById("js_more_friend_cmt_area"),
morefd:document.getElementById("js_more_friend_cmt"),
fakebar:document.getElementById("js_fake_bar"),
showAll:document.getElementById("js_cmt_show_all"),
showAllWording:document.getElementById("js_cmt_show_all_wording"),
listContainer:document.getElementById("js_cmt_list_container"),
cmtContainer:document.getElementById("js_cmt_container"),
inputPC:document.getElementById("js_cmt_input_pc"),
containerPC:document.getElementById("js_cmt_container_pc"),
commentPC:document.getElementById("js_comment_pc"),
addbtnPC:document.getElementById("js_cmt_addbtn_pc"),
myareaPC:document.getElementById("js_cmt_myarea_pc"),
emotionSwitchPC:document.getElementById("js_emotion_wrp_pc"),
deletePanel:document.getElementById("js_delete_panel"),
deleteConfirm:document.getElementById("js_delete_confirm"),
deleteCancel:document.getElementById("js_delete_cancel"),
inputHolder:document.getElementById("js_cmt_input_holder"),
el_alertPanel:document.getElementById("js_alert_panel"),
el_alertContent:document.getElementById("js_alert_content"),
el_alertConfirm:document.getElementById("js_alert_confirm"),
addCmtBtn1:document.getElementById("js_cmt_addbtn1"),
addCmtBtn2:document.getElementById("js_cmt_addbtn2"),
addCmtBtn3:document.getElementById("js_cmt_addbtn3"),
addCmtBtn4:document.getElementById("js_cmt_addbtn4")
},window.__second_open__&&J.os.ios&&(At.mine.style.marginBottom=getComputedStyle(At.fakebar).height),
!t.notAutoGetComment&&j({
forceRefresh:!0,
cb:h
}),E(),Jt&&I(),on.init(),O(),Jt&&U();
}
function W(){
F();
}
e("biz_common/utils/string/html.js");
var G=e("biz_common/dom/class.js"),Y=e("appmsg/cmt_tpl.html.js"),V=e("biz_common/utils/wxgspeedsdk.js"),Q=e("appmsg/comment_report.js"),J=e("biz_wap/utils/device.js"),X=e("appmsg/retry_ajax.js"),Z=e("biz_common/dom/offset.js"),$=e("biz_common/utils/url/parse.js"),K=e("biz_wap/jsapi/core.js"),et=e("common/utils.js"),tt=e("appmsg/emotion/selection.js"),nt=e("appmsg/i18n.js"),ot=e("biz_common/dom/event.js"),it=e("biz_wap/utils/ajax.js"),mt=e("biz_common/tmpl.js"),dt=e("biz_wap/utils/fakehash.js"),st=e("appmsg/log.js"),at=e("appmsg/my_comment_tpl.html.js"),lt=e("appmsg/emotion/dom.js"),ct=e("pages/utils.js"),rt=e("biz_wap/utils/mmversion.js"),_t=e("common/comm_report.js"),pt=e("biz_wap/utils/position.js"),ut=e("appmsg/set_font_size.js"),gt=e("common/color/background_color.js"),ft=e("biz_wap/utils/jsmonitor_report.js"),wt=!window.isPaySubscribe||window.isPaySubscribe&&window.isPaid,yt={
Bizuin_from:window.biz,
Msgid_from:window.parseInt(window.mid,10)||0,
Itemidx_from:window.parseInt(window.idx,10)||0,
Scene:window.parseInt(window.source,10)||0,
Subscene:window.parseInt(window.subscene,10)||0,
Sessionid:window.sessionid||"",
Enterid:window.parseInt(window.enterid,10)||0,
Useruin:1*window.user_uin
},ht=0;
try{
ht=1*window.atob(window.biz);
}catch(jt){}
var Ct={
BizUin:ht,
BizUinStr:window.biz||"",
AppMsgId:window.parseInt(window.mid,10)||0,
ItemIdx:window.parseInt(window.idx,10)||0,
ItemShowType:window.parseInt(window.item_show_type,10)||0,
SessionIdStr:window.sessionid||"",
EnterId:window.parseInt(window.enterid,10)||0,
Scene:window.parseInt(window.source,10)||0,
SubScene:window.parseInt(window.subscene,10)||0
},vt={
scene:0,
idkey:"",
moreList:27,
repeatList:25,
errList:18,
handleList:26,
addCommentErr:19,
errComment:18,
repeatContent:24,
repeatContentID:23
},bt=void 0,Bt=void 0,It=void 0,kt=void 0,Et=void 0,Tt=void 0,xt=window.comment_id,St=0,Pt=void 0,Lt=!1,Mt="",Ht=!1,zt=0,Dt=[],At={},Rt=[],Nt="",Ft="我",Ot=0,Ut={},qt=Date.now(),Wt=!1,Gt=void 0,Yt=void 0,Vt=100,Qt=location.href,Jt=J.os.pc,Xt="comment_editing",Zt="my_comment_empty_data",$t=navigator.userAgent.indexOf("MicroMessenger")>-1,Kt=document.getElementById("js_cmt_area"),en=document.getElementById("js_friend_cmt_area"),tn=document.getElementById("js_cmt_container"),nn=Qt.indexOf("vconsole=1")>0||document.cookie&&document.cookie.indexOf("vconsole_open=1")>-1,on=e(Jt?"appmsg/emotion/emotion_pc.js":"appmsg/emotion/emotion.js"),mn="http://mmbiz.qpic.cn/mmbiz/ByCS3p9sHiak6fjSeA7cianwo25C0CIt5ib8nAcZjW7QT1ZEmUo4r5iazzAKhuQibEXOReDGmXzj8rNg/0",dn=["“”","‘’","（）","《》","〈〉","「」","『』","〔〕","【】","［］","[]","｛｝","{}","()","<>"],sn=function(e){
K.invoke("setNavigationBarColor",{
color:e
}),K.invoke("setBounceBackground",{
backgroundColor:e
});
},an=window.isOldVideoPage;
if(!et.isNativePage()){
var ln=["#ffffff"];
ln.push(G.hasClass(document.body,Xt)?"#191919":"#232323"),gt.set({
nav:ln,
top:ln
});
}
return window.pageCommentReportData&&window.pageCommentReportData.idkey&&(nn&&console.log("init reportData"),
vt=window.pageCommentReportData),"undefined"!=typeof window.comment_id?xt=window.comment_id:window.cgiData&&"undefined"!=typeof window.cgiData.comment_id&&(xt=window.cgiData.comment_id),
$t||(Kt&&(Kt.style.display="none"),en&&(en.style.display="none"),xt=0),nn&&console.info("[图文评论] 评论ID:",xt),
W(),{
initComment:q,
getCommentData:j,
renderComment:h
};
});define("appmsg/like.js",["biz_common/dom/event.js","biz_common/dom/class.js","biz_wap/utils/ajax.js","biz_common/base64.js","biz_wap/utils/jsmonitor_report.js","appmsg/log.js","complain/tips.js","appmsg/retry_ajax.js","biz_wap/jsapi/core.js","biz_wap/utils/mmversion.js","common/utils.js","appmsg/loading.js","appmsg/i18n.js","biz_wap/utils/device.js","appmsg/pay_report_utils.js"],function(require,exports,module,alert){
"use strict";
function qs(e){
return document.getElementById(e);
}
function showAppToast(e,i){
JSAPI.invoke("handleMPPageAction",{
action:"showToast",
wording:e||"",
status:i||"success"
});
}
function initLikeEvent(opt){
function show(e){
e.style.display="";
}
function hide(e){
e.style.display="none";
}
function vShow(e){
e.style.visibility="visible";
}
function vHide(e){
e.style.visibility="hidden";
}
function clear(e){
e.value="";
}
function showLoading(){
commonUtils.isNativePage()?showAppToast("发送中","loading"):Loading.show("发送中");
}
function hideLoading(){
commonUtils.isNativePage()?showAppToast("","dismissloading"):Loading.hide();
}
function showToast(e){
commonUtils.isNativePage()?showAppToast(e):(el_toastMsg.innerHTML=e,show(el_likeToast),
setTimeout(function(){
hide(el_likeToast);
},1e3));
}
function newAlert(e){
el_alertContent.innerHTML=e,el_alertPanel.style.display="";
}
function alert2(e){
"0"===window.item_show_type?newAlert(e):alert(e);
}
function failAlert(e){
return e&&e.length>maxLikeCommentWord?void alert2("想法不可以超过%s字".replace("%s",maxLikeCommentWord)):void alert2("网络异常，请稍后重试");
}
function isAppCommentAvailable(){
return mmversion.isWechat?Device.os.ipad?!1:mmversion.isInMiniProgram?!1:mmversion.isIOS&&mmversion.gtVersion("7.0.8")?!0:mmversion.isAndroid&&mmversion.gtVersion("7.0.8")?!0:commonUtils.isNativePage()&&(mmversion.isIOS||mmversion.isAndroid)?!0:!1:!1;
}
var scrollTop,el_like=opt.likeAreaDom,el_likeNum=opt.likeNumDom,showType=opt.showType,prompted=opt.prompted,haokanLock=!1,startY,jumpWowLock=!1,el_likeToast=qs("js_like_toast"),el_likeBtn=qs("js_like_btn"),el_toastMsg=qs("js_toast_msg"),el_likeEducate=qs("js_like_educate"),el_friend_like=qs("js_friend_like_area"),el_go_wow=qs("js_go_wow"),el_likeComment=qs("js_like_comment"),el_bcommentPanel2=qs("js_comment_panel"),el_likeCommentShare=qs("js_like_comment_share"),el_likeCommentText=qs("js_comment_text"),el_commentCancel=qs("js_comment_cancel"),el_commentConfirm=qs("js_comment_confirm"),el_commentErrorMsg=qs("js_like_comment_msg"),el_commentCurrentCount=qs("js_like_current_cnt"),el_commentArea=qs("js_comment_area"),el_panelLikeTitle=qs("js_panel_like_title"),el_wowClosePanel=qs("wow_close_inform"),el_wowCloseAck=qs("wow_close_ack"),el_alertPanel=qs("js_alert_panel"),el_alertContent=qs("js_alert_content"),el_alertConfirm=qs("js_alert_confirm");
if(el_like&&el_likeNum){
window.appmsg_like_type&&2===window.appmsg_like_type?jsmonitorReport.setSum(114217,0,1):window.appmsg_like_type&&1===window.appmsg_like_type&&jsmonitorReport.setSum(114217,1,1);
var like_report=function(){
var e=el_like.getAttribute("like"),i=el_likeNum.innerHTML,t=parseInt(e)?parseInt(e):0,o=t?0:1,n=parseInt(i)?parseInt(i):0,s=opt.appmsgid||opt.mid,l=opt.itemidx||opt.idx;
if(t){
if(1!==appmsg_like_type)return void sendRecommendAjax(0);
Class.removeClass(el_like,opt.className),el_like.setAttribute("like",0),n>0&&"100000+"!==i&&(el_likeNum.innerHTML=n-1==0?"赞":n-1);
}else if(1===appmsg_like_type)el_like.setAttribute("like",1),Class.addClass(el_like,opt.className),
"100000+"!==i&&(el_likeNum.innerHTML=n+1);else if(2===appmsg_like_type)return void initRecommendPanel();
RetryAjax({
url:"/mp/appmsg_like?__biz="+opt.biz+"&mid="+opt.mid+"&idx="+opt.idx+"&like="+o+"&f=json&appmsgid="+s+"&itemidx="+l,
data:{
is_temp_url:opt.is_temp_url||0,
scene:window.source,
subscene:window.subscene,
appmsg_like_type:window.appmsg_like_type,
item_show_type:parseInt(window.item_show_type,10),
client_version:window.clientversion,
action_type:o?1:2,
device_type:window.devicetype
},
type:"POST"
});
},initRecommendPanel=function(){
sendRecommendAjax(1,"",1);
},isBeenUnvisible=function(e){
function i(){
return window.pageYOffset||document.documentElement.scrollTop||document.body.scrollTop||0;
}
return e.offsetTop+el_likeComment.offsetHeight-i()>=commonUtils.getInnerHeight()?!0:!1;
},disableMove=function(){
document.addEventListener("touchmove",preventMove,{
passive:!1
}),el_likeCommentText.addEventListener("touchstart",getTouchStart,{
passive:!1
}),el_likeCommentText.addEventListener("touchmove",preventText,!1);
},enableMove=function(){
document.removeEventListener("touchmove",preventMove,{
passive:!1
}),el_likeCommentText.removeEventListener("touchstart",getTouchStart,{
passive:!1
}),el_likeCommentText.removeEventListener("touchmove",preventText,!1);
},preventMove=function(e){
var i=e.target;
"TEXTAREA"!==i.tagName&&"BUTTON"!==i.tagName&&(e.preventDefault(),e.stopPropagation());
},getTouchStart=function(e){
var i=e.targetTouches||[];
if(i.length>0){
var t=i[0]||{};
startY=t.clientY;
}
},preventText=function(e){
var i=!1,t=e.changedTouches,o=this.scrollTop,n=this.offsetHeight,s=this.scrollHeight;
if(t.length>0){
var l=t[0]||{},a=l.clientY;
i=a>startY&&0>=o?!1:startY>a&&o+n>=s?!1:!0,i||e.preventDefault();
}
},isShow=function(e){
return"none"===e.style.display||"hidden"===e.style.visibility?!1:""===e.style.display||"block"===e.style.display||"visible"===e.style.visibility?!0:void 0;
},validataComment=function(e,i){
var t=e.value.replace(/^\s+|\s+$/g,"");
sendRecommendAjax(1,t,i);
},showEducatePanel=function(e,i,t){
show(el_likeComment);
var o=window.source||window.cgiData&&window.cgiData.source||0;
return o&&(o=parseInt(o,10),94===o)?void(e&&5===e&&hide(el_likeComment)):void(i||(show(el_likeEducate),
t&&t>0&&(el_friend_like.innerHTML="%s位朋友也在看,".replace("%s",t),document.getElementById("js_friend_like_word").innerText="前往“发现”-“看一看”浏览",
show(el_friend_like)),1===showType&&(hide(el_go_wow),hide(el_likeCommentShare)),
isBeenUnvisible(el_likeComment)&&scrollToShow(el_likeComment),educateExpose()));
},setBtnLike=function(){
el_like.setAttribute("like",1),Class.addClass(el_likeBtn,opt.className),realLikeNum+=1;
var e=el_likeNum.innerHTML;
"10万+"!==e&&(el_likeNum.innerHTML=dealLikeReadShow(realLikeNum));
},setLike2Status=function(e,i,t){
var o="在看";
switch(showType){
case 1:
switch(prompted){
case 0:
showEducatePanel(e,i,t),show(el_likeComment),prompted=1;
break;

case 1:
hide(el_likeEducate),showToast(o);
}
setBtnLike();
break;

case 2:
switch(hide(el_bcommentPanel2),clear(el_likeCommentText),prompted){
case 0:
showEducatePanel(e,i,t),5===e&&hide(el_likeCommentShare);
break;

case 1:
(4===e||5===e)&&showToast(4===e?"已发送":o);
}
5!==e&&(4===e&&"none"!==el_likeEducate.style.display?hide(el_likeCommentShare):4===e?hide(el_likeComment):(show(el_commentArea),
show(el_likeCommentShare),1===prompted&&hide(el_likeEducate),show(el_likeComment),
isBeenUnvisible(el_likeComment)&&scrollToShow(el_likeComment))),4!==e&&setBtnLike(),
prompted=1;
}
enableMove(),commonUtils.isNativePage()&&JSAPI.invoke("handleHaokanAction",{
action:"closeComment"
}),log("[Appmsg] zaikan set like success");
},unsetLike2Status=function(e){
1===e?setTimeout(function(){
alert2(" 已取消，想法已同步删除");
},20):showToast("已取消"),2===showType&&isShow(el_likeComment)&&hide(el_likeComment);
var i=el_likeNum.innerHTML;
Class.removeClass(el_likeBtn,opt.className),el_like.setAttribute("like",0),el_likeComment&&hide(el_likeComment),
realLikeNum-=1,realLikeNum>=0&&"10万+"!==i&&(el_likeNum.innerHTML=dealLikeReadShow(realLikeNum)),
log("[Appmsg] zaikan set unlike success");
},sendRecommendAjax=function sendRecommendAjax(like,comment,type,clientType){
if(!haokanLock){
log("[Appmsg] prepare to send appmsg like request"),showLoading();
var appmsgid=opt.appmsgid||opt.mid,itemidx=opt.itemidx||opt.idx;
haokanLock=!0;
var action_type;
like?(window.isPaySubscribe&&payReportUtils.reportPayAppmsg(12),action_type=type):(window.isPaySubscribe&&payReportUtils.reportPayAppmsg(13),
action_type=2),ajax({
url:"/mp/appmsg_like?__biz="+opt.biz+"&mid="+opt.mid+"&idx="+opt.idx+"&like="+like+"&f=json&appmsgid="+appmsgid+"&itemidx="+itemidx,
data:{
is_temp_url:opt.is_temp_url||0,
scene:window.source,
subscene:window.subscene,
appmsg_like_type:window.appmsg_like_type,
item_show_type:parseInt(window.item_show_type,10),
client_version:window.clientversion,
comment:comment?comment:"",
prompted:1,
style:clientType||showType,
action_type:action_type,
passparam:window.passparam,
request_id:(new Date).getTime(),
device_type:window.devicetype
},
type:"POST",
success:function success(res){
haokanLock=!1;
var data=eval("("+res+")");
hideLoading(),log("[Appmsg] success send appmsglike like "+like+" return value is "+JSON.stringify(res)),
0==data.base_resp.ret?(like?setLike2Status(type,data.is_eu_user,data.friend_like_num):unsetLike2Status(data.has_comment),
connectWithApp(like,comment,clientType)):failAlert(comment);
},
error:function(){
hideLoading(),failAlert(),haokanLock=!1;
}
});
}
};
JSAPI.on("menu:haokan",function(e){
var i=0===parseInt(e.recommend)?0:1;
if(0===i)sendRecommendAjax(i,"",2,clientShowType);else{
var t="";
t=e.comment;
var o=1===e.scene?4:5;
sendRecommendAjax(i,t,o,clientShowType);
}
});
var connectWithApp=function(e,i){
var t={
origin:"mp",
isLike:e?1:0,
url:encodeURIComponent(msg_link.html(!1)),
content:i?i:""
};
JSAPI.invoke("handleHaokanAction",{
action:actionString,
recommend:e?1:0,
server_data:JSON.stringify(t)
},function(e){
console.log("handleHaokanAction",e);
}),JSAPI.invoke("handleHaokanAction",{
action:actionForClient,
permission:1,
recommend:e?1:0
},function(e){
console.log("handleHaokanAction for client",e);
});
},goWoW=function(){
jumpWowLock||(jumpToWowClickReport(),jumpWowLock=!0,JSAPI.invoke("handleHaokanAction",{
action:"jumpToWow",
extParams:JSON.stringify({
autoDropLoad:!0
})
},function(e){
jumpWowLock=!1,console.log("jumpToWow",e),e.err_msg&&"handleHaokanAction:fail_entrance_not_open"===e.err_msg?show(el_wowClosePanel):"handleHaokanAction:fail  action not support"===e.err_msg||"handleHaokanAction:fail, action not support"===e.err_msg?alert2("微信版本过低，暂不支持该操作"):"handleHaokanAction:ok"===e.err_msg&&hide(el_likeComment),
JSAPI.invoke("handleHaokanAction",{
action:actionString,
server_data:JSON.stringify({
origin:"mp",
autoDropLoad:!0
})
},function(e){
console.log("sendAutoDropLoad",e);
});
}));
},likeClickReport=function(){
ajax({
url:"/mp/appmsgreport?action=appmsglikeclickcomment&__biz="+opt.biz+"&mid="+opt.mid+"&idx="+opt.idx+"&f=json&appmsgid="+appmsgid+"&itemidx="+itemidx,
data:{
is_temp_url:opt.is_temp_url||0,
scene:window.source,
subscene:window.subscene,
appmsg_like_type:window.appmsg_like_type,
item_show_type:parseInt(window.item_show_type,10),
client_version:window.clientversion,
device_type:window.devicetype
},
type:"POST"
});
},likeExpose=function e(){
var i=document.documentElement.scrollTop||window.pageYOffset||document.body.scrollTop,t=qs("like3").offsetTop,o=opt.appmsgid||opt.mid,n=opt.itemidx||opt.idx;
i+commonUtils.getInnerHeight()>t&&t>=i&&(ajax({
url:"/mp/appmsgreport?action=appmsglikeexposure&__biz="+opt.biz+"&mid="+opt.mid+"&idx="+opt.idx+"&f=json&appmsgid="+o+"&itemidx="+n,
data:{
is_temp_url:opt.is_temp_url||0,
scene:window.source,
subscene:window.subscene,
appmsg_like_type:window.appmsg_like_type,
item_show_type:parseInt(window.item_show_type,10),
client_version:window.clientversion,
device_type:window.devicetype
},
type:"POST"
}),DomEvent.off(window,"scroll",e));
},educateExpose=function i(){
var e=(document.documentElement.scrollTop||window.pageYOffset||document.body.scrollTop,
opt.appmsgid||opt.mid),t=opt.itemidx||opt.idx,o=window.item_show_type,n=window.enterid||window.cgiData&&window.cgiData.enterid||"";
el_likeEducate&&"none"!=el_likeEducate.style.display&&commonUtils.getInnerHeight()>el_likeEducate.getBoundingClientRect().top&&el_likeEducate.getBoundingClientRect().top+el_likeEducate.getBoundingClientRect().height>0&&(ajax({
url:"/mp/webcommreport?action=report&report_useruin=1&__biz="+window.biz,
type:"POST",
data:{
logid:18266,
buffer:["",Base64.decode(opt.biz),e,t,window.source,window.subscene,1,o,sessionid,n]
},
async:!1,
timeout:2e3
}),DomEvent.off(window,"scroll",i));
},jumpToWowClickReport=function(){
var e=opt.appmsgid||opt.mid,i=opt.itemidx||opt.idx,t=window.enterid||window.cgiData&&window.cgiData.enterid||"";
ajax({
url:"/mp/webcommreport?action=report&report_useruin=1&__biz="+window.biz,
type:"POST",
data:{
logid:18266,
buffer:["",Base64.decode(opt.biz),e,i,window.source,window.subscene,2,window.item_show_type,sessionid,t]
},
async:!1,
timeout:2e3
});
};
DomEvent.on(el_alertConfirm,"click",function(){
el_alertPanel.style.display="none";
}),DomEvent.on(el_like,"click",function(e){
var i=el_like.getBoundingClientRect();
return log("[Appmsg zaikan location] top: "+i.top+" left: "+i.left+" bottom: "+i.bottom+" right: "+i.right),
log("[Appmsg zaikan click] clientX: "+e.clientX+" clientY: "+e.clientY),e.currentTarget.classList.contains("js_disabled")?!1:(like_report(e),
!1);
}),DomEvent.on(el_wowCloseAck,"click",function(){
hide(el_wowClosePanel);
}),DomEvent.on(qs("js_mask_2"),"mousedown",function(){
hide(el_bcommentPanel2),clear(el_likeCommentText),vHide(el_commentErrorMsg),enableMove();
}),DomEvent.on(el_commentConfirm,"mousedown",function(){
validataComment(el_likeCommentText,4);
}),DomEvent.on(el_commentCancel,"mousedown",function(){
hide(el_bcommentPanel2),clear(el_likeCommentText),vHide(el_commentErrorMsg),enableMove();
}),DomEvent.on(el_likeCommentShare,"click",function(){
return commonUtils.isNativePage()?void JSAPI.invoke("handleHaokanAction",{
action:"writeComment",
style:window.isOldVideoPage?"black":"white"
}):(scrollTop=document.body.scrollTop||document.documentElement.scrollTop,1*window.item_show_type===10&&(el_panelLikeTitle.innerHTML=window.msg_title.replace(/<(\/?)(?=((a(\s|>))|(\/a))).*?>/g,"")),
show(el_bcommentPanel2),el_likeCommentText.focus(),el_commentConfirm.setAttribute("disabled","disabled"),
disableMove(),void likeClickReport());
}),DomEvent.on(el_likeCommentText,"focus",function(){}),DomEvent.on(el_likeCommentText,"blur",function(){
window.scrollTo(0,scrollTop);
}),DomEvent.on(window,"scroll",likeExpose),DomEvent.on(window,"scroll",educateExpose),
DomEvent.on(el_go_wow,"click",goWoW);
var scrollToShow=function(e){
e.scrollIntoView(!1);
};
DomEvent.on(el_likeCommentText,"input",function(e){
var i=el_likeCommentText.value.replace(/^\s+|\s+$/g,"");
i.length>maxLikeCommentWord?(el_commentCurrentCount.innerHTML=i.length,vShow(el_commentErrorMsg)):vHide(el_commentErrorMsg),
i.length>0&&i.length<=maxLikeCommentWord?el_commentConfirm.removeAttribute("disabled"):el_commentConfirm.setAttribute("disabled","disabled"),
Device.os.ios&&e.data&&doubleInputChar.indexOf(e.data)>-1&&(focusTag=!0);
}),DomEvent.on(el_likeCommentText,"click",function(){
Device.os.ios&&focusTag&&(el_likeCommentText.blur(),el_likeCommentText.focus(),focusTag=!1);
});
}
}
function showLikeNum(e){
var i=e||{};
if(i.show){
var t=i.likeAreaDom,o=i.likeNumDom,n=document.getElementById("js_like_btn");
t&&(t.style.display=i.likeAreaDisplayValue,t.style.visibility="",i.liked&&(1===appmsg_like_type?Class.addClass(t,i.className):Class.addClass(n,i.className)),
t.setAttribute("like",i.liked?"1":"0"));
var s=1===appmsg_like_type?"赞":"";
realLikeNum=i.likeNum||s,1===appmsg_like_type?(parseInt(realLikeNum)>1e5?realLikeNum="100000+":"",
o&&(o.innerHTML=realLikeNum)):2===appmsg_like_type&&(o.innerHTML=dealLikeReadShow(realLikeNum));
}
}
function dealLikeReadShow(e){
if("en"==LANG)return i18n.dealLikeReadShow_en(e);
var i="";
if(parseInt(e)>1e5)i="10万+";else if(parseInt(e)>1e4&&parseInt(e)<=1e5){
var t=""+parseInt(e)/1e4,o=t.indexOf(".");
i=-1===o?t+"万":t.substr(0,o)+"."+t.charAt(o+1)+"万";
}else i=0===parseInt(e)?"":e;
return i;
}
function showReadNum(e){
var i=e||{},t=1586325600,o="undefined"!=typeof window.ct?parseInt(window.ct):0;
if(i.show){
var n=i.readAreaDom,s=i.readNumDom;
n&&(n.style.display=i.readAreaDisplayValue);
var l=i.readNum||1,a=window.ori_send_time||window.cgiData&&window.cgiData.ori_send_time||0,m=/(WindowsNT)|(Windows NT)|(Macintosh)/i.test(navigator.userAgent),r=1566025200,p=1565971200,c=Device.os.ios||m?r:p;
parseInt(a,10)>c&&window.item_show_type&&"5"===window.item_show_type&&(t>o?("en"!=LANG&&(document.getElementById("readTxt").innerText="播放"),
l=i.videouv||0):("en"!=LANG&&(document.getElementById("readTxt").innerText="观看"),
l=i.readNum||0)),1===appmsg_like_type?(parseInt(l)>1e5?l="100000+":"",s&&(s.innerHTML=l)):2===appmsg_like_type&&(s.innerHTML=dealLikeReadShow(l),
""===s.innerHTML&&(s.innerHTML="0"));
}
}
var DomEvent=require("biz_common/dom/event.js"),Class=require("biz_common/dom/class.js"),ajax=require("biz_wap/utils/ajax.js"),Base64=require("biz_common/base64.js"),jsmonitorReport=require("biz_wap/utils/jsmonitor_report.js"),log=require("appmsg/log.js"),Tips=require("complain/tips.js"),RetryAjax=require("appmsg/retry_ajax.js"),JSAPI=require("biz_wap/jsapi/core.js"),actionString="submitMsgToTL",actionForClient="update_recommend_status",mmversion=require("biz_wap/utils/mmversion.js"),commonUtils=require("common/utils.js"),Loading=require("appmsg/loading.js"),realLikeNum,clientShowType=5,i18n=require("appmsg/i18n.js"),Device=require("biz_wap/utils/device.js"),payReportUtils=require("appmsg/pay_report_utils.js"),maxLikeCommentWord=200,focusTag=!1,doubleInputChar=["“”","‘’","（）","《》","〈〉","「」","『』","〔〕","【】","［］","[]","｛｝","{}","()","<>"];
return{
initLikeEvent:initLikeEvent,
showLikeNum:showLikeNum,
showReadNum:showReadNum
};
});var _extends=Object.assign||function(e){
for(var t=1;t<arguments.length;t++){
var i=arguments[t];
for(var n in i)Object.prototype.hasOwnProperty.call(i,n)&&(e[n]=i[n]);
}
return e;
};
define("appmsg/related_article.js",["biz_common/utils/string/html.js","biz_common/tmpl.js","biz_wap/utils/ajax.js","biz_wap/jsapi/core.js","appmsg/related_article_tpl.html.js","biz_wap/utils/openUrl.js","biz_common/dom/event.js","common/utils.js","biz_common/dom/class.js","biz_common/utils/url/parse.js","appmsg/i18n.js","common/comm_report.js","appmsg/related_article_feedback.js","biz_wap/utils/mmversion.js","biz_wap/utils/device.js","appmsg/set_font_size.js","biz_wap/utils/jsmonitor_report.js"],function(e){
"use strict";
function t(){
return document.documentElement.scrollTop||document.body.scrollTop;
}
function i(e){
var t=document.createElement("div");
return t.innerHTML=e,t.childNodes;
}
function n(){
A.setSum(110809,24,1),h.report(18832,_extends({
Actiontype:2,
Type:2,
Bizuin:0,
Msgid:0,
Itemidx:0,
Sendtimestamp:0,
Pos:0
},U));
}
function s(){
n();
var e="https://mp.weixin.qq.com/mp/relatedarticle?action=page&begin=0&article_url="+window.encodeURIComponent(location.href)+"&__biz="+window.biz+"&mid="+window.mid+"&idx="+window.idx+"&sessionid="+(window.enterid||"")+"&enterid="+parseInt(Date.now()/1e3,0)+"&scene_from="+window.source+"&subscene_from="+window.subscene+"#wechat_redirect";
return I.isWechat?(I.isAndroid&&u.invoke("checkJsApi",{
jsApiList:["currentMpInfoHide"]
},function(e){
try{
e.err_msg.indexOf("ok")>-1&&u.invoke("currentMpInfoHide");
}catch(t){
console.log(t);
}
}),w.openUrlWithExtraWebview(e)):window.open(e),!1;
}
function o(e){
e?(S.style.display="none",H.style.display=""):(S.style.display="",H.style.display="none");
}
function r(e){
R=!0,e&&(M.style.display=""),H.style.display="none",S.style.display="none";
}
function a(e){
var t=arguments.length<=1||void 0===arguments[1]?0:arguments[1],n=arguments.length<=2||void 0===arguments[2]?N:arguments[2];
p({
url:"/mp/relatedarticle?action=getlist&count="+n+"&begin="+t+"&article_url="+window.encodeURIComponent(location.href)+"&__biz="+window.biz+"&mid="+window.mid+"&idx="+window.idx,
type:"GET",
dataType:"json",
success:function(o){
o&&o.list&&o.list.length>0&&(window.has_related_article=!0);
var a=function(){
if(o&&o.base_resp&&1*o.base_resp.ret===0)if(O=o.article_size||0,0===o.list.length)P?r(0!==t):f.addClass(T,"hide");else{
E.style.display="block";
for(var e=o.list.map(function(e){
if("en"===window.LANG)e.read_num_wording=j.dealLikeReadShow_en(e.read_num);else if(window.parseInt(e.read_num)>1e5)e.read_num_wording="10万+";else if(window.parseInt(e.read_num)>1e4&&window.parseInt(e.read_num)<=1e5){
var t=""+window.parseInt(e.read_num)/1e4,i=t.indexOf(".");
e.read_num_wording=-1===i?t+"万":t.substr(0,i)+"."+t.charAt(i+1)+"万";
}else e.read_num_wording=0===window.parseInt(e.read_num)?"":e.read_num;
return e;
}),a=m.tmpl(_,{
list:e,
reason:W,
begin:t
}),d=i(a),l=0;l<d.length;l++)B.appendChild(d[l].cloneNode(!0));
P?(o.list.length<n||o.article_size<=t+n)&&r(0!==t):o.article_size===n?(Q=!1,f.addClass(T,"hide")):o.article_size>n&&(Q=!0,
f.removeClass(T,"hide"),g.on(T,"click",s)),window.ipados13_font_scale&&x(B,window.ipados13_font_scale/100);
}
};
"function"==typeof e?e("sucess",a):a();
},
error:function(){
"function"==typeof e&&e("error");
}
});
}
function d(){
for(var e=document.getElementsByClassName("js_related_item"),i=t(),n=0;n<e.length;n++){
var s=e[n];
1*s.getAttribute("data-hasreport")!==1&&s.clientHeight+s.offsetTop>=i+s.clientHeight/2&&s.clientHeight+s.offsetTop<=i+s.clientHeight/2+y.getInnerHeight()&&!function(e,t){
var i=e.getAttribute("data-url"),n=e.getAttribute("data-time"),s=e.getAttribute("data-recalltype");
e.setAttribute("data-hasreport",1),A.setSum(110809,21,1),h.report(18832,_extends({
Actiontype:1,
Type:1,
Bizuin:b.getQuery("__biz",i),
Msgid:window.parseInt(b.getQuery("mid",i),10)||0,
Itemidx:window.parseInt(b.getQuery("idx",i),10)||0,
Sendtimestamp:window.parseInt(n)||0,
Pos:t+1,
Recalltype:1*s
},U));
}(s,n);
}
O>1&&1*T.getAttribute("data-hasreport")!==1&&T.clientHeight+T.offsetTop>=i+T.clientHeight/2&&T.clientHeight+T.offsetTop<=i+T.clientHeight/2+y.getInnerHeight()&&!function(e){
e.setAttribute("data-hasreport",1),A.setSum(110809,22,1),h.report(18832,_extends({
Actiontype:1,
Type:2,
Bizuin:0,
Msgid:0,
Itemidx:0,
Sendtimestamp:0,
Pos:0
},U));
}(T);
}
function l(){
n(),o(!0),L+=N,a(function(e,t){
o(!1),"sucess"===e&&t();
},L);
}
function c(){
g.on(B,"click",".js_related_item",function(e){
var t=e.delegatedTarget,i=t.getAttribute("data-url"),n=t.getAttribute("data-time"),s=t.getAttribute("data-recalltype"),o=(1*t.getAttribute("data-idx")||0)+1;
A.setSum(110809,23,1),h.report(18832,_extends({
Actiontype:2,
Type:1,
Bizuin:b.getQuery("__biz",i),
Msgid:window.parseInt(b.getQuery("mid",i),10)||0,
Itemidx:window.parseInt(b.getQuery("idx",i),10)||0,
Sendtimestamp:window.parseInt(n)||0,
Pos:o,
Recalltype:1*s
},U)),I.isWechat?w.openUrlWithExtraWebview(i):window.open(i);
}),g.on(B,"touchstart",".js_related_item",function(e){
e.stopPropagation();
var t=e.delegatedTarget;
f.addClass(t,"card_custom_active");
},!1),g.on(B,"touchend",".js_related_item",function(e){
e.stopPropagation();
var t=e.delegatedTarget;
f.removeClass(t,"card_custom_active");
},!1),g.on(window,"scroll",d),P&&(g.on(S,"click",l),g.on(C,"click",function(){
C.style.display="none",l();
})),z.init({
container:B,
biz:window.biz,
mid:window.mid,
idx:window.idx,
dislikeCb:function(e){
1===B.children.length&&(P&&!R?(S.style.display="none",C.style.display=""):!P&&Q?(B.style.display="none",
T.style.display="none",k.style.display="",g.off(T,"click",s),g.on(k,"click",s)):E.style.display="none"),
e.parentNode.removeChild(e);
}
});
}
e("biz_common/utils/string/html.js");
var m=e("biz_common/tmpl.js"),p=e("biz_wap/utils/ajax.js"),u=e("biz_wap/jsapi/core.js"),_=e("appmsg/related_article_tpl.html.js"),w=e("biz_wap/utils/openUrl.js"),g=e("biz_common/dom/event.js"),y=e("common/utils.js"),f=e("biz_common/dom/class.js"),b=e("biz_common/utils/url/parse.js"),j=e("appmsg/i18n.js"),h=e("common/comm_report.js"),z=e("appmsg/related_article_feedback.js"),I=e("biz_wap/utils/mmversion.js"),v=e("biz_wap/utils/device.js"),x=e("appmsg/set_font_size.js").setFontSize,A=e("biz_wap/utils/jsmonitor_report.js"),E=document.getElementById("js_related_area"),B=document.getElementById("js_related"),T=document.getElementById("js_related_load_more"),k=document.getElementById("js_more_article"),S=document.getElementById("js_related_load_more_pc"),H=document.getElementById("js_related_loading_pc"),C=document.getElementById("js_more_article_pc"),M=document.getElementById("js_related_all_pc"),P=v.os.ipad||!I.isIOS&&!I.isAndroid,O=0,Q=!1,U={
Bizuin_from:window.biz,
Msgid_from:window.parseInt(window.mid,10)||0,
Itemidx_from:window.parseInt(window.idx,10)||0,
Scene:window.parseInt(window.source,10)||0,
Subscene:window.parseInt(window.subscene,10)||0,
Sessionid:window.sessionid||"",
Enterid:window.parseInt(window.enterid,10)||0
},W=[{
name:"内容质量低",
value:1
},{
name:"不看此公众号",
value:2
}],N=P?3:1,R=!1,L=0;
return P&&(document.getElementById("js_related_opr").style.display="none",document.getElementById("js_related_opr_pc").style.display=""),
c(),a;
});define("appmsg/share_tpl.html.js",[],function(){
return'<div class="rich_media_extra">\n    <a href="<#= url #>" class="share_appmsg_container appmsg_card_context flex_context">\n        <div class="flex_hd">\n            <i class="share_appmsg_icon"> </i>\n        </div>\n        <div class="flex_bd">\n            <div class="share_appmsg_title">分享给订阅用户</div>\n            <p class="share_appmsg_desc">可快速分享原创文章给你的公众号订阅用户</p>\n        </div>\n    </a>\n</div>\n';
});define("appmsg/appmsgext.js",["appmsg/log.js","biz_wap/utils/ajax.js","rt/appmsg/getappmsgext.rt.js","biz_common/utils/wxgspeedsdk.js"],function(e){
"use strict";
function s(e){
function s(e){
for(var s=window.location.href,t=s.indexOf("?"),i=s.substr(t+1),_=i.split("&"),a=0;a<_.length;a++){
var n=_[a].split("=");
if(n[0].toUpperCase()==e.toUpperCase())return n[1];
}
return"";
}
var r={
biz:"",
appmsg_type:"",
mid:"",
sn:"",
idx:"",
scene:"",
title:"",
ct:"",
abtest_cookie:"",
devicetype:"",
version:"",
is_need_ticket:0,
is_need_ad:0,
comment_id:"",
is_need_reward:0,
both_ad:0,
reward_uin_count:0,
send_time:"",
msg_daily_idx:"",
is_original:0,
is_only_read:0,
req_id:"",
pass_ticket:"",
is_temp_url:0,
more_read_type:0,
rtId:"",
rtKey:"",
appmsg_like_type:1,
related_video_sn:"",
vid:"",
is_pay_subscribe:0,
pay_subscribe_uin_count:0,
has_red_packet_cover:0,
onSuccess:function(){},
onError:function(){}
};
for(var d in e)e.hasOwnProperty(d)&&(r[d]=e[d]);
console.info("[(评论、点赞、赞赏) 发送请求]: ",new Date),i({
url:"/mp/getappmsgext?f=json&mock="+s("mock"),
data:{
r:Math.random(),
__biz:r.biz,
appmsg_type:r.appmsg_type,
mid:r.mid,
sn:r.sn,
idx:r.idx,
scene:r.scene,
title:encodeURIComponent(r.title.htmlDecode()),
ct:r.ct,
abtest_cookie:r.abtest_cookie,
devicetype:r.devicetype.htmlDecode(),
version:r.version.htmlDecode(),
is_need_ticket:r.is_need_ticket,
is_need_ad:r.is_need_ad,
comment_id:r.comment_id,
is_need_reward:r.is_need_reward,
both_ad:r.both_ad,
reward_uin_count:r.is_need_reward?r.reward_uin_count:0,
send_time:r.send_time,
msg_daily_idx:r.msg_daily_idx,
is_original:r.is_original,
is_only_read:r.is_only_read,
req_id:r.req_id,
pass_ticket:r.pass_ticket,
is_temp_url:r.is_temp_url,
item_show_type:r.item_show_type,
tmp_version:1,
more_read_type:r.more_read_type,
appmsg_like_type:r.appmsg_like_type,
related_video_sn:r.related_video_sn,
vid:r.vid,
is_pay_subscribe:r.is_pay_subscribe,
pay_subscribe_uin_count:r.pay_subscribe_uin_count,
has_red_packet_cover:r.has_red_packet_cover
},
type:"POST",
dataType:"json",
rtId:r.rtId,
rtKey:r.rtKey,
rtDesc:_,
async:!0,
success:function(e){
if(console.info("[(评论、点赞、赞赏) 响应请求]: ",new Date,e),t("[Appmsg] success get async data"),
"function"==typeof r.onSuccess&&r.onSuccess(e),e)try{
t("[Appmsg] success get async data, async data is: "+JSON.stringify(e));
}catch(s){}else t("[Appmsg] success get async data, async data is empty");
if(!n&&"5"===window.item_show_type){
var i=Date.now()-window.logs.pagetime.page_begin;
if(n=!0,Math.random()>.1)return;
a.saveSpeeds({
uin:window.uin,
pid:675,
speeds:[{
sid:29,
time:i
}]
}),a.send();
}
},
error:function(){
t("[Appmsg] error get async data, biz="+r.biz+", mid="+r.mid),"function"==typeof r.onError&&r.onError();
}
});
}
var t=e("appmsg/log.js"),i=e("biz_wap/utils/ajax.js"),_=e("rt/appmsg/getappmsgext.rt.js"),a=e("biz_common/utils/wxgspeedsdk.js"),n=void 0;
return{
getData:s
};
});