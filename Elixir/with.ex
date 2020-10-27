content = "Now is the time"
lp = with {:ok, file} = File.open("/etc/passwd"),
          content = IO.read(file, :all), # note: same name as above
          :ok = File.close(file),
          [_, uid, gid] <- Regex.run(~r/^lp:.*?:(\d+):(\d+)/m, content)
    do
      "Group: #{gid}, User: #{uid}"
    end
IO.puts lp #=> Group: 26, User: 26  如果失敗直接返回nil
IO.puts content #=> Now is the time

# 當使用<-時，如果pattern match失敗會直接返回nil
# 這裏切記with 後面要緊跟表達式，不可以直接換行寫，因爲背後其實是把with當一個function調用
