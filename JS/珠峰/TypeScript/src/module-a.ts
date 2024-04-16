export class Zoo {
  static monkey = "动物园的猴子";
}

export namespace Zoo {
  let el = "动物园里面的大象";
  export let dog: string = "动物园的狗";
}
export namespace Zoo {
  export let cat: string = "动物园的猫";
}
export namespace Home {
  export let dog: string = "家里面的狗";

  export namespace X {
    export let dog: string = "家里面x的狗";
  }
}

function counter(): number {
  return counter.count++;
}
namespace counter {
  // 额外不需要暴露给外面的扩展
  export let count = 0;
}

enum ROLE {}

namespace ROLE {
  export let user = 1;
  export let manager = 1;
  export let admin = 1;
}
ROLE.admin;

// 命名空间主要就是给对象扩展属性，可以做到产生一个作用域
