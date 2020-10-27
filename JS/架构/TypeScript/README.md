##  对TS比较好的
- 前端  angular  react 比较好  vue 不太好
- 后端 express nest.js koa  对TS的支持也非常好

## 问题
- type 和interface的区别与联系?
  - type只是定义一个类型别名 interface才是真正的类型
  - type a = string|number;  
- 类和接口的区别都有哪些?
  - 接口只是一个类型  只是用来去修饰对象或者被类去实现的,经过TS编译之后就会消失
  - 类既是类型(指的是类的实例的类型)，也是值 构造函数，编译之后还在
- 类的接口和抽象类区别都有哪些？
  - 接口就是接口 类就是类
  - 类可以实现接口
  - 抽象类就是不能被实例化类，不能new的类
- extends implements的区别是什么？
  - 只有类才能实现接口 class xx implements interface
  - 接口要以继承接口 interface child extends father
  - 类可以继承类  class child extends father