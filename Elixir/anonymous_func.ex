sum = fn a, b -> a + b end
sum.(1, 2)

# anonymous function with pattern matching
swap = fn { a, b } -> { b, a } end
swap.( { 6, 8 } )

# one function with multiple bodies
handle_open = fn
  {:ok, file} -> "Read data: #{IO.read(file, :line)}"
  {_, error} -> "Error: #{:file.format_error(error)}"
end

# pin value with function
defmodule Greeter do
  def for(name, greeting) do
    fn
      (^name) -> "#{greeting} #{name}"
      (_) -> "I don't know you"
    end
  end
end

mr_valim = Greeter.for("José", "Oi!")
IO.puts mr_valim.("José") # => Oi! José
IO.puts mr_valim.("Dave") # => I don't know you

# & operator
# &(&1 + &2) 等同於 fn p1, p2 -> p1 + p2
# 當匿名函數內部調用函數且使用參數的順序相同(注意必須相同)時可以再簡化, e.g.
# &(IO.puts(&1)) 等同於 &IO.puts/1 

# list或tuple也可以使用&, e.g.
# divrem = &{ div(&1,&2), rem(&1,&2) }
# divrem.(13, 5) // {2, 3}

# &也可作用與string
# s = &"bacon and #{&1}"
# s.("custard") // "bacon and custard"
# match_end = &~r/.*#{&1}$/
# "cat" =~ match_end.("t") // true