## Type Checking

- noImplicitAny 是否校验没有赋予类型的变量，默认启用 any
- strictNullChecks 是否进行严格的 null 严格检测 null
- strictFunctionTypes 此属性支持双向协变（让参数可以进行协变操作）
- strictBindCallApply 保证调用这个函数的时候参数是一致的
- strictPropertyInitialization 类中的属性进行属性的初始化才能使用
- noImplicitThis 默认 this 是 any ， 需要避免 any
- useUnknownInCatchVariables catch 中的 error 类型是 unknown 不在是 any
- alwaysStrict 永远打包的结果 都增加严格模式
- noUnusedLocals 如果变量未被使用会发生警告
- noUnusedParameters 针对参数的类型校验
- exactOptionalPropertyTypes 类型中属性是可选的，如果要传递 undefined 需要自己添加 undefined 类型
- noImplicitReturns 返回值是否保证每条路径都有
- noFallthroughCasesInSwitch 防止 switch case 缺少 break 语句
- noUncheckedIndexedAccess 正常通过索引访问应该添加一个 undefined 类型
- noImplicitOverride 让用户在使用的时候，必须重写方法前加 override
- noPropertyAccessFromIndexSignature 只能通过[]来访问属性
- allowUnusedLabels 循环的 label 未使用时报警告
- allowUnreachableCode 代码未触达 会发生异常

# 完整性

- skipDefaultLibCheck 是否跳过 ts 中的内置类型
- skipLibCheck 跳过检测第三方类型

## 额外的属性

- references

# 项目相关

- incremental 增量编译
- tsBuildInfoFile 增量文件编译的名字
- disableSourceOfProjectReferenceRedirect 符合项目的时候 引用选用的是源文件而不是声明文件
- disableSolutionSearching 引用其他项目时是否检测引用的项目
- disableReferencedProjectLoad 禁用引用项目的加载
- composite 复合项目，被引用的需要增加
- referernces 引用其他的项目
- include: [**/*] // glob 语法 \*_ 就是任意目录 _ 任意文件
- exclude 排除 include 进来的不需要的
