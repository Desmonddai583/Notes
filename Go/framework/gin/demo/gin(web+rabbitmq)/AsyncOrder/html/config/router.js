const routes = [
    { path: '/', component: httpVueLoader( 'components/order.vue' ) },

];
const router = new VueRouter({
    routes
});
export default router