# elixir中，在一次pattern matching中一个变量只能绑定一次
# [a, a] = [1, 2] 会报错
# 当然在多次pattern matching中是可以绑定不同的值的(这点也是elixir和erlang的不同之处)
# 如果不希望变量可以被再次绑定可以在变量前加一个^
