const routes = [
    { path: '/',name:"index", component: httpVueLoader( 'components/index.vue' ) },
    { path: '/login',name:"login", component: httpVueLoader( 'components/login.vue' ) },
    { path: '/auth_code', component: httpVueLoader( 'components/authcode.vue' ) },
    { path: '/depts',name:"deptslist", component: httpVueLoader( 'components/depts.vue' ) },
];
const router = new VueRouter({
    routes
});
export default router