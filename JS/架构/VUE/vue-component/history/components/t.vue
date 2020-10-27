<template>
    <div>
        t.vue
        {{$attrs}}
        <button @click="$listeners.click"></button>
    </div>
</template>

<script>
export default {
    mounted(){
        console.log(this.$listeners)
    }
}
</script>