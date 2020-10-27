import elMenu from "./components/el-menu.vue";
import elMenuItem from "./components/el-menu-item.vue";
import elSubmenu from "./components/el-submenu.vue";


export  default {
    props:{
        data:{
            type:Array,
            default:()=>[]
        }
    },
    render(){ // react语法 
        let renderChildren  = (data) =>{
            return data.map(child=>{
                return child.children? 
                <elSubmenu>
                    <div slot="title">{child.title}</div>
                    {renderChildren(child.children)}
                </elSubmenu>:
                <elMenuItem nativeOnClick={()=>{
                    alert(1)
                }}>{child.title}</elMenuItem>
            })
        }
        return <elMenu>
            {renderChildren(this.data)}
        </elMenu>
    }
}