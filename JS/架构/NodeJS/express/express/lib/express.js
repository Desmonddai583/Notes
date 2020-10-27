// 应用系统
const Application = require('./application');
const Router = require('./router/index');

// 创建应用 
function createApplication() {
    return new Application(); 
}
createApplication.Router = Router
module.exports = createApplication;