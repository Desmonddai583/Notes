import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/home.vue'
Vue.use(Router)

export let authRoutes = [
  {
    path:'/clothing',
    name:'clothing',
    component:()=>import('./views/clothing.vue'),
    children:[
      {
        path:'men-wear',
        name:'men-wear',
        component:()=>import('./views/men-wear.vue'),
        children:[
          {
            path:'shirt',
            name:'shirt',
            component:()=>import('./views/shirt.vue')
          }
        ]
      },
      {
        path:'women-wear',
        name:'women-wear',
        component:()=>import('./views/women-wear.vue'),
        children:[
          {
            path:'skirt',
            name:'skirt',
            component:()=>import('./views/skirt.vue')
          }
        ]
      }
    ]
  },
  {
    path: '/liquor',
    name: 'liquor',
    component: ()=>import('./views/liquor.vue')
  },
  {
    path: '/medicine',
    name: 'medicine',
    component: ()=>import('./views/medicine.vue')
  }
]

export default new Router({
  mode: 'hash',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '*',
      component: {
        render:h => h('h1',{},'not found')
      }
    }
  ]
})
