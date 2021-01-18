const routes = [
    { path: '/', component: httpVueLoader( 'components/booklist.vue' ) },

];
const router = new VueRouter({
    routes
});
export default router