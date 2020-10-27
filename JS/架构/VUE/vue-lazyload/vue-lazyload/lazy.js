// 存放懒加载功能的文件
import {throttle,debounce} from 'lodash'
export default (Vue) =>{
    class ReactiveListener{
        constructor({el,src,elRenderer,options}){
            this.el = el;
            this.src = src;
            this.elRenderer =elRenderer;
            this.options = options;
            this.state = {loading:false}

        }
        checkInView(){ // 判断是否渲染
            let {top} = this.el.getBoundingClientRect(); // 高度就是图片的位置
            return top < window.innerHeight * this.options.preLoad
        }
        load(){ // 加载当前的listener
            // 开始渲染 渲染前 需要默认渲染loading状态
            this.elRenderer(this,'loading');
            loadImageAsync(this.src,()=>{
                this.state.loading = true; // 加载完毕了
                this.elRenderer(this,'loaded');
            },()=>{
                this.elRenderer(this,'error');
            }); // 异步加载图片
        }
    } 
    function loadImageAsync(src,resolve,reject){
        let image = new Image();
        image.src = src;
        image.onload = resolve;
        image.onerror = reject
    }
    return class LazyClass{
        constructor(options){
            this.options = options; // 将用户传入的数据保存到当前的实例上
            this.listenerQueue = [];
            this.bindHandler = false;

            // 在一段时间内 不停的触发方法
            //  防抖(最终触发一次) 节流(默认每隔一段时间执行一次)
            this.lazyLoadHandler = throttle(()=>{ 
                let catIn = false;
                this.listenerQueue.forEach(listener=>{
                    if(listener.state.loading) return ; // 如果已经渲染过的图片就不在进行渲染了
                    catIn = listener.checkInView(); // 判断是否应该渲染
                    catIn && listener.load(); // 加载对应的listener
                })
            },500)
        }
        add(el,bindings,vnode){
            // 需要监控父亲的滚动事件 ，当滚动时候 来检测当前的图片是否出现在了 可视区域内
            // addEventListener('scroll')  监控当前图片是否在显示区域的范围
            // 这里获取不到真实的dom
            Vue.nextTick(()=>{
                function scrollParent(){
                    let parent = el.parentNode;
                    while(parent){
                        if(/scroll/.test(getComputedStyle(parent)['overflow'])){
                            return parent;
                        }
                        parent = parent.parentNode // 不停的向上找 找带有overflow的属性
                    }
                    return parent
                }
                let parent = scrollParent();
                // 我要判断当前这个图片是否要加载
                let src = bindings.value; // 对应的v-lazy的值
                let listener = new ReactiveListener({
                    el, // 真实的dom
                    src,
                    elRenderer:this.elRenderer.bind(this),
                    options:this.options, // {默认会看是渲染loading}
                });
                this.listenerQueue.push(listener);
                if(!this.bindHandler){
                    this.bindHandler = true;
                    console.log('绑定一次')
                    parent.addEventListener('scroll',this.lazyLoadHandler); // 滚动时判断
                }   
               
                // 默认需要先进行一次判断 
                this.lazyLoadHandler();
            });
        }
        elRenderer(listener,state){ // 渲染当前实例的什么状态
            let {el} = listener;
            let src = ''
            switch (state) {
                case 'loading':
                    src = listener.options.loading || ''
                    break;
                case 'error':
                    src = listener.options.error || ''
                default:
                    src = listener.src
                    break;
            }
            el.setAttribute('src',src);
        }
    }
}