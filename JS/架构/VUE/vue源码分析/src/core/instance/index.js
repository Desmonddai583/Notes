import { initMixin } from './init'
import { stateMixin } from './state'
import { renderMixin } from './render'
import { eventsMixin } from './events'
import { lifecycleMixin } from './lifecycle'
import { warn } from '../util/index'

// vue的构造函数
function Vue (options) {
  if (process.env.NODE_ENV !== 'production' &&
    !(this instanceof Vue)
  ) {
    warn('Vue is a constructor and should be called with the `new` keyword')
  }
  this._init(options)
}
// 就是给vue的构造函数 添加原型的方法
initMixin(Vue) // Vue.prototype._init
stateMixin(Vue) // initState 初始化状态的
eventsMixin(Vue) // Vue.prototype.$on / Vue.prototype.$emit
lifecycleMixin(Vue) // Vue.prototype._update
renderMixin(Vue) // Vue.prototype._render

export default Vue


