<template>
    <div>
        son2 {{parent.mny}}
        <Grandson @drink="drink"></Grandson>
    </div>
</template>

<script>
import Grandson from './grandson';
export default {
    name:'son2',
    inject:['parent'],
    components:{
        Grandson
    },
    methods:{
        drink(){
            console.log('喝水')
        }
    }
}
</script>