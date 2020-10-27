# 在iex中通过(i 变量名或值)来查看变量或值信息
# iex中可以使用IEx.configure来配置iex的设定
# e.g. IEx.configure colors: [ eval_result: [ :cyan, :bright ] ] 设定返回值颜色
# IEx.configure colors: [enabled: false] 关闭色彩效果，如果你的命令行不支持ANSI escape sequences

# elixir中以ex结尾将会被编译后在执行，而exs则会在运行时直接解释，一般测试代码文件会使用exs格式
# 在iex中，使用(c "文件名")进行编译运行
# c方法的返回值为一个列表，里面放着该文件所导入的模块

# 在iex中，使用import_file可以导入文件