bin = << 1, 2 >>
byte_size bin  # 2

bin = <<3 :: size(2), 5 :: size(4), 1 :: size(2)>>
:io.format("~-8.2b~n", :binary.bin_to_list(bin)) # 11010101
byte_size bin # 1