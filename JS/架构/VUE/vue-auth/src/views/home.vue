<template>
    <div>
        <li v-for="auth in $store.state.authList" :key="auth.name">
            <router-link :to="{name:auth.auth}">{{auth.name}}</router-link>
        </li>
    </div>  
</template>