# elixir的有名函数必须写在module中
# 3 way to write function body
# 1
def double(n), do: n * 2
# 2 
def double(n), do: (
  n * 2
)
# 3
def double(n) do
  n * 2
end

# Pattern Matching with named function
# elixir 会从上至下匹配，所以这里of(0)必须放在前面
defmodule Factorial do
  def of(0), do: 1
  def of(n) when is_integer(n) and n > 0 do
    n * of(n-1)
  end
end

# Guard clauses
defmodule Guard do
  def what_is(x) when is_number(x) do
    IO.puts "#{x} is a number"
  end
  def what_is(x) when is_list(x) do
    IO.puts "#{inspect(x)} is a list"
  end
  def what_is(x) when is_atom(x) do
    IO.puts "#{x} is an atom"
  end
end

# Default parameters
defmodule Example do
  def func(p1, p2 \\ 2, p3 \\ 3, p4) do
    IO.inspect [p1, p2, p3, p4]
  end
end

Example.func("a", "b") # => ["a",2,3,"b"]
Example.func("a", "b", "c") # => ["a","b",3,"c"]

# 以下定义方法是错误的，因为第一个函数已经包含了第二个函数的调用方法
# 第一个函数可以只接受两个参数，所以第二个永远不会被调用
def func(p1, p2 \\ 2, p3 \\ 3, p4) do
  IO.inspect [p1, p2, p3, p4]
end
def func(p1, p2) do
  IO.inspect [p1, p2]
end

# elixir为了避免多个function文法加默认值产生的混乱，所以以下这种写法会报错
defmodule DefaultParams1 do
  def func(p1, p2 \\ 123) do
    IO.inspect [p1, p2]
  end
  def func(p1, 99) do
    IO.puts "you said 99"
  end
end

# 需要加一个没有body的function head才可以
defmodule Params do
  def func(p1, p2 \\ 123)
  def func(p1, p2) when is_list(p1) do
    "You said #{p2} with a list"
  end
  def func(p1, p2) do
    "You passed in #{p1} and #{p2}"
  end
end

# defp可以定义私有函数，只有在定义它的模块内部才可以调用

# 私有函数也可以像上面一样有多个multiple heads
# 但是必须全部是私有或者全部是共有，不可以混着定义


# Module
# 如何访问模块中的函数
defmodule Outer do
  defmodule Inner do
    def inner_func do
    end
  end
    
  def outer_func do
    Inner.inner_func
  end
end

Outer.outer_func
Outer.Inner.inner_func

# 不管是否有nested，elixir背后其实是将所有模块都定义在最顶层
# 所以可以用以下方式定义nested模块
defmodule Mix.Tasks.Doctest do
  def run do
  end
end
Mix.Tasks.Doctest.run

# 模块的3种指令
# 1 import
# import导入的方法或macro前面不需要再加模块名
import List, only: [ flatten: 1, duplicate: 2 ]

# 这里也可以使用 
import List, only: :functions # 或者:macros
# 这样就会只引入函数或者macros

# 2 alias
alias My.Other.Module.Parser, as: Parser
# 或者可以简写成以下形式，as默认会拿最后一part
alias My.Other.Module.Parser
# 多个时还可以写成
alias My.Other.Module.{Parser, Runner}

# 3 require
# 用来引入模块中的macros，它会保证在代码编译时可以访问到macro的定义


# Module Attribute
# 模块属性主要用做定义配置和元数据
# 模块属性可以多次定义
# 调用函数时属性值取决于定义函数时属性的值
defmodule Example do
  @attr "one"
  def first, do: @attr
  @attr "two"
  def second, do: @attr
end
IO.puts "#{Example.second} #{Example.first}" # => two one


# 当我们定义模块时，模块名背后其实就是加了Elixir的一个atom
:"Elixir.IO" === IO
:"Elixir.Dog" === Dog
IO.puts 123 # :"Elixir.IO".puts 123
# 甚至可以写成
my_io = IO
my_io.puts 123

# 如果我们调用的是Erlang的库，则直接使用库名的atom即可
:io.format("The number is ~3.1f~n", [5.678])

