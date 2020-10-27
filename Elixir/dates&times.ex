d1 = Date.new(2018, 12, 25) # {:ok, ~D[2018-12-25]}
d2 = ~D[2018-12-25] # ~D[2018-12-25]
d1 == d2 # true
Date.day_of_week(d1) # 2
Date.add(d1, 7) # ~D[2019-01-01]
inspect d1, structs: false # "%{__struct__: Date, calendar: Calendar.ISO, day: 25, month: 12, year: 2018}"

d1 = ~D[2018-01-01]
d2 = ~D[2018-06-30]
first_half = Date.range(d1, d2) # DateRange<~D[2018-01-01], ~D[2018-06-30]>
Enum.count(first_half) # 181
~D[2018-03-15] in first_half # true
 
{:ok, t1} = Time.new(12, 34, 56) # {:ok, ~T[12:34:56]}
t2 = ~T[12:34:56.78] # ~T[12:34:56.78]
t1 == t2 # false
Time.add(t1, 3600) # ~T[13:34:56.000000]
Time.add(t1, 3600, :millisecond) # ~T[12:34:59.600000]

# NaiveDateTime只包含date和time， DateTime還包含timezone
# ~N[...]用來創建NaiveDateTime結構