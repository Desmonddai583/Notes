const person = {
  name: "jw",
  get aliasName() {
    return this.name + "handsome";
  },
};

let proxyPerson = new Proxy(person, {
  get(target, key, recevier) {
    // recevier 是代理对象
    console.log(key);
    return target[key];
    // return Reflect.get(target, key, recevier); // (recevier[key]); // person.name 不会触发get
  },
});

console.log(proxyPerson.aliasName);
