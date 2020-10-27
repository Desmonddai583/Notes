export default {
    props:{
        type:String | Number
    },
    methods:{
        handleClick(e){
            console.log(e.target)
        },
        handleInput(e){
           this.msg = e.target.value
        }
    },
    data(){
      return {msg:'zf'}
    },
    mounted(){
    },
    render(h){ // jsx => js + xml 去写代码
        // h('h'+this.type,{},[this.$slots.default])
        let tag = 'h' + this.type
        return <tag>
            <input type="text" value={this.msg} onInput={this.handleInput}/>
            <span  onClick={this.handleClick}>{this.$slots.default}</span>
            {this.msg}
        </tag>

        // https://github.com/vuejs/babel-plugin-transform-vue-jsx#difference-from-react-jsx
    }
}