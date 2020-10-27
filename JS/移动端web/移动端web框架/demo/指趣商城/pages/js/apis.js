var baseURL = "https://weixin.itzb.com/web/?lnj=api/";
var defaultIndex = "default/index";
var defaultNavs = "default/navbar"; // 底部导航
var defaultCats = "default/cat-list"; // 分类
var defaultCart = "cart/list&access_token=7apWBXl1llqEKJUlQ2_qHaptxbeZ5zeu"; // 购物车
var defaultGoods = "default/goods&access_token=7apWBXl1llqEKJUlQ2_qHaptxbeZ5zeu";

/**
 * 获取API相关的数据
 * @param url  API地址
 * @param success  成功的回调
 * @param error  失败的回调
 */
function getAPI(url, success, error) {
    $.ajax({
        url: baseURL + url,
        type: "get",
        success: function (obj) {
            // 根据拿到的数据做相应的处理
            if(obj.code === 0 && obj.msg === "success"){
                success(obj);
            }else{
                error("获取数据失败");
            }
        },
        error: function () {
            error("获取数据失败");
        }
    });
}

/**
 * 获取首页默认的API数据
 * @param success  成功的回调
 * @param error  失败的回调
 */
function getDefaultModule(success, error) {
    getAPI(defaultIndex, success, error);
}
/**
 * 获取默认底部导航的API数据
 * @param success  成功的回调
 * @param error  失败的回调
 */
function getDefaultNavbar(success, error) {
    getAPI(defaultNavs, success, error);
}
/**
 * 获取分类的API数据
 * @param success  成功的回调
 * @param error  失败的回调
 */
function getDefaultCat(success, error) {
    getAPI(defaultCats, success, error);
}

/**
 * 获取购物车的API数据
 * @param success  成功的回调
 * @param error  失败的回调
 */
function getDefaultCart(success, error) {
    getAPI(defaultCart, success, error);
}

function getGoodsById(id, success, error) {
    $.ajax({
        url: baseURL + defaultGoods,
        type: "get",
        data: {"id": id},
        success: function (obj) {
            // 根据拿到的数据做相应的处理
            if(obj.code === 0){
                success(obj);
            }else{
                error("获取数据失败");
            }
        },
        error: function () {
            error("获取数据失败");
        }
    });
}