Regex.run ~r{[aeiou]}, "caterpillar"  # ["a"]
Regex.scan ~r{[aeiou]}, "caterpillar" # [["a"], ["e"], ["i"], ["a"]]
Regex.split ~r{[aeiou]}, "caterpillar" # ["c", "t", "rp", "ll", "r"]
Regex.replace ~r{[aeiou]}, "caterpillar", "*" # "c*t*rp*ll*r"

# regex后面可以跟的选项
f Force the pattern to start to match on the first line of a multiline string.
i Make matches case insensitive.
m If the string to be matched contains multiple lines, ^ and $ match the start
and end of these lines. \A and \z continue to match the beginning or end of
the string.
s Allow . to match any newline characters.
U Normally modifiers like * and + are greedy, matching as much as possible.
The U modifier makes them ungreedy, matching as little as possible.
u Enable unicode-specific patterns like \p.
x Enable extended mode—ignore whitespace and comments (# to end of line).