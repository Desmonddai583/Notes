package conf

type Config struct {
	Models map[string][]string
	Rule   Rule
}

func NewConfig() Config {
	mod := make(map[string][]string)
	mod["users"] = []string{"users1", "users2"}

	return Config{Models: mod, Rule: UseRangeRule()}
}
func UseRangeRule() *RangeRule { //使用范围分表
	rangerule := NewRangeRule("user_id")
	rangerule.AddRange(100, 0, "users1")
	rangerule.AddRange(1000, 101, "users2")
	return rangerule
}
