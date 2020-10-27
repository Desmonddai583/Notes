# elixir中的tuple比較類似與其他語言中的array
# list則不是，它背後是鏈式結構

# list操作
[ 1, 2, 3 ] ++ [ 4, 5, 6 ]  # 合並[1, 2, 3, 4, 5, 6]
[1, 2, 3, 4] -- [2, 4] # 取異值[1, 3]

# 如果keywordlist是最後一個參數可以省略方括號 e.g.
# DB.save record, [ {:use_transaction, true}, {:logging, "HIGH"} ]
# 簡寫爲 DB.save record, use_transaction: true, logging: "HIGH"
# 在任何context下如果keywordlist是最後一個出現的item也可以簡寫 e.g.
# [1, fred: 1, dave: 2] 背後其實就是[1, {:fred, 1}, {:dave, 2}]
# 或 {1, fred: 1, dave: 2} 背後其實就是{1, [fred: 1, dave: 2]}
# keywordlist的key可以重復，但是map不可以

