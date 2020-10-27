// 应用系统
const Application = require('./application');

// 创建应用 
function createApplication() {
    return new Application(); 
}
module.exports = createApplication;