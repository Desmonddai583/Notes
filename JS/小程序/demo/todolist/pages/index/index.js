Page({
  data: {
    person: {
        name: "",
        age: ""
    },
    list: [
      {
        name: "lnj",
        age:33
      },
      {
        name: "zq",
        age: 18
      }
    ]
  },
  change(e){
    let key = e.currentTarget.dataset.type;
    let person = Object.assign({}, this.data.person);
    person[key] = e.detail.value;
    this.setData({
      person: person
    });
  },
  add(){
    let list = this.data.list;
    list.push(this.data.person);
    this.setData({
      list: list
    });
  },
  remove(e){
    let index = e.currentTarget.dataset;
    let list = this.data.list;
    list.splice(index, 1);
    this.setData({
      list: list
    });
  }
})
