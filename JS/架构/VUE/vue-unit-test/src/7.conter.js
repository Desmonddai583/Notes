export default class Counter{
    constructor(){
        this.count = 0;
    }
    add(val){
        this.count+=val;
        return this;
    }
    minus(val){
        this.count-=val;
        return this;
    }
}