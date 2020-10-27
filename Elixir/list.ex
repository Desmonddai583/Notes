# 在iex中，如果列表中的所有元素都可以代表一个codepoint
# iex就会将它解释成stirng，注意这里是单引号的string
[99, 97, 116] # 'cat'
[99, 97, 116, 0] # [99, 97, 116, 0] '0' is nonprintable

# 这里我们想使用head，当时
defmodule WeatherHistory do
  def for_location([], _target_loc), do: []
  def for_location([ head = [_, target_loc, _, _ ] | tail], target_loc) do
    [ head | for_location(tail, target_loc) ]
  end
  def for_location([ _ | tail], target_loc), do: for_location(tail, target_loc)
end