<template>
    <div>
        grandson
        {{parent.mny}}

        <button @click="$dispatch('eat','parent','饭')">触发son2的事件</button>
    </div>
</template>

<script>
// $parent指代的是父组件 
// $children指代的是子组件

// element-ui 内部就是了这一套机制 就是触发事件是只要父亲绑定过这个方法就触发
export default {
    name:'grandson',
    inject:['parent']
}
</script>