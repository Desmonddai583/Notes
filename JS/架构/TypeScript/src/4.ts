/**
 * 抽象类
 * 抽象描述一种抽象的状态，无法被实例人，只能被继承
 * 抽象方法不能在抽象类中实现，只能在具体子类中实现,而且 必须实现
 */
abstract class Animal {
    name: string;
    abstract speak(): void
}
class Cat extends Animal {
    speak(): void {
        console.log('喵喵喵');
    }
}
let cat = new Cat();
cat.speak();
class Dog extends Animal {
    speak(): void {
        console.log('汪汪汪');
    }
}
let dog = new Dog();
dog.speak();
/**
 * 修饰符
 * 访问控制修饰符 private protected public 
 * 只读 readonly 用在编译阶段的
 * 静态属性 static
 * 抽象类 抽象方法 abstract
 */
/**
 * 重写和重载
 * 重载指的是为一个函数提供多个类型 定义，或者说函数声明
 * 重写 不同的子类以不同的方式实现父类的方法
 */

 /**
  * 继承和多态
  * 
  */


export { }