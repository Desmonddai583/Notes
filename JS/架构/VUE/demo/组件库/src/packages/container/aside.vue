<template>
    <aside class="zh-aside" :style="{width}">
        <slot>
            
        </slot>
    </aside>
</template>

<script>
export default {
    name:'zh-aside',
    props:{
        width:{
            type:String,
            default:'300px'
        }
    }
}
</script>