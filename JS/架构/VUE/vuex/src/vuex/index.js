let Vue;
let forEach = (obj, callback) => {
    Object.keys(obj).forEach(key => {
        callback(key, obj[key]);
    })
}
class ModuleCollection {
    constructor(options) {
        this.register([], options);
    }
    register(path, rootModule) {
        let rawModule = {
            _raw: rootModule,
            _children: {},
            state: rootModule.state
        }
        rootModule.rawModule = rawModule // 双向记录 在用户传入的对象中记录下 自己的模块
        if (!this.root) {
            this.root = rawModule
        } else { // [b,'c']
            let parentModule = path.slice(0, -1).reduce((root, current) => {
                return root._children[current];
            }, this.root);
            parentModule._children[path[path.length - 1]] = rawModule
        }
        if (rootModule.modules) {
            forEach(rootModule.modules, (moduleName, module) => {
                this.register(path.concat(moduleName), module)
            })
        }
    }
}

function getState(store, path) { // [a]
    let local = path.reduce((newState, current) => {
        return newState[current]; // 每次调用mutation的时候传入的参数我都保证他是最新获取到的，而不是默认安装时的数据
    }, store.state);
    return local
}

function installModule(store, rootState, path, rawModule) {
    let getters = rawModule._raw.getters;
    // 根据当前用户传入的配置 算一下他需不需要增加一个前缀
    let root = store.modules.root // 获取到了最终整个的格式化的结果
    // [a,b]  => a/b
    // [a]  => a
    let namespace = path.reduce((str, current) => {
        // 这个root是整个格式化的
        // root._children[current] 拿到的是当前通过路径获取到的模块
        root = root._children[current]; // 拿到对应的格式化的结果
        str = str + (root._raw.namespaced ? current + '/' : '');
        return str; // a/b/
    }, '');
    if (path.length > 0) { // 儿子模块
        let parentState = path.slice(0, -1).reduce((root, current) => {
            return rootState[current]
        }, rootState)
        Vue.set(parentState, path[path.length - 1], rawModule.state);
    }
    if (getters) {
        forEach(getters, (getterName, value) => {
            Object.defineProperty(store.getters, namespace + getterName, {
                get: () => {
                    return value(getState(store, path))
                }
            })
        })
    }
    let mutations = rawModule._raw.mutations;
    if (mutations) {
        forEach(mutations, (mutationName, value) => {
            let arr = store.mutations[namespace + mutationName] || (store.mutations[namespace + mutationName] = []);
            arr.push((payload) => { // 为什么要切片
                value(getState(store, path), payload); // 真正执行mutation的地方
                store.subs.forEach(fn => fn({
                    type: namespace + mutationName,
                    payload: payload
                }, store.state));
            })
        })
    }
    let actions = rawModule._raw.actions;
    if (actions) {
        forEach(actions, (actionName, value) => {
            let arr = store.actions[namespace + actionName] || (store.actions[namespace + actionName] = []);
            arr.push((payload) => {
                value(store, payload)
            })
        })
    }
    forEach(rawModule._children, (moduleName, rawModule) => {
        installModule(store, rootState, path.concat(moduleName), rawModule)
    })
}
class Store {
    constructor(options) {
        this.strict = options.strict || false;
        this._committing = false; // 默认是没有提交
        this.vm = new Vue({
            data: {
                state: options.state
            }
        });
        this.getters = {};
        this.mutations = {};
        this.actions = {};
        this.subs = [];
        // 一下功能已经执行完毕了
        this.modules = new ModuleCollection(options) //格式化我们想要的数据结构
        installModule(this, this.state, [], this.modules.root);

        let plugins = options.plugins;
        plugins.forEach(plugin => plugin(this));
        if(this.strict){
            this.vm.$watch(()=>{
                return this.vm.state
            },function () {
                console.assert(this._committing,'不能异步调用')
                // 希望他可以深度监控 （异步执行的）
            },{deep:true,sync:true}); // 监控了是否采用同步的方式更改了数据
        }   
     
    }
    _withCommit(fn){
        const committing = this._committing; // 保留false
        this._committing = true; // 默认调用mutation之前会先 更改值是true
        fn();
        this._committing = committing
    }
    replaceState(newState) {
        this._withCommit(()=>{
            this.vm.state = newState; // 更新状态
        })
    }
    subscribe(fn) {
        this.subs.push(fn);
    }
    commit = (mutationName, payload) => {
        this._withCommit(()=>{ // 装饰  切片
          this.mutations[mutationName].forEach(fn => fn(payload));
        })
    }
    dispatch = (actionName, payload) => {
        this.actions[actionName].forEach(fn => fn(payload));
    }
    get state() {
        return this.vm.state
    }
    registerModule(moduleName, module) {
        this._committing = true
        if (!Array.isArray(moduleName)) {
            moduleName = [moduleName]
        }
        
        this.modules.register(moduleName, module); // 添加到我们自己格式化的树中了 
            // 将当前这个模块进行安装 // [d], {_raw,_children,state}
    
            // 只安装当前的木块
       installModule(this, this.state, moduleName, module.rawModule);
    }
}

// 官方api
const install = (_Vue) => {
    Vue = _Vue;
    Vue.mixin({
        beforeCreate() {
            if (this.$options.store) {
                this.$store = this.$options.store
            } else {
                this.$store = this.$parent && this.$parent.$store
            }
        }
    })
}
export const mapState = (stateArr) => { // {age:fn}
    let obj = {};
    stateArr.forEach(stateName => {
        obj[stateName] = function () {
            return this.$store.state[stateName]
        }
    });
    return obj;
}

export function mapGetters(gettersArr) {
    let obj = {};
    gettersArr.forEach(getterName => {
        obj[getterName] = function () {
            return this.$store.getters[getterName];
        }
    });
    return obj
}

export function mapMutations(obj) {
    let res = {};
    Object.entries(obj).forEach(([key, value]) => {
        res[key] = function (...args) {
            this.$store.commit(value, ...args)
        }
    })
    return res;
}
export function mapActions(obj) {
    let res = {};
    Object.entries(obj).forEach(([key, value]) => {
        res[key] = function (...args) {
            this.$store.dispatch(value, ...args)
        }
    })
    return res;
}
export default {
    Store,
    install
}