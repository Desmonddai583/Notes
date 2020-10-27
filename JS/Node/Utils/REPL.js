let repl = require('repl');
// 可以帮我们创建一个repl的上下文

let context = repl.start().context;
context.zfpx = 'zfpx';
context.age = 9;