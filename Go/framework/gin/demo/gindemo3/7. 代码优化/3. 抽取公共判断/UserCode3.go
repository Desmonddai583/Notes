package code

func IsA(userid int) bool { return userid > 10 }
func IsB(userid int) bool { return userid > 15 }
func IsC(userid int) bool { return userid > 20 }

type BoolFunc func(int) bool //第一抽取 公共函数体
func And(id int, fs ...BoolFunc) bool {
	if len(fs) == 0 {
		return false
	}
	v := fs[0](id)
	for index := range fs {
		if index == 0 {
			continue
		}
		v = v && fs[index](id)
	}
	return v
}
func Or(id int, f1 BoolFunc, f2 BoolFunc) bool {
	return f1(id) || f2(id)
}

// 获取用户等级
func GetUserLevel(userid int) int {
	if And(userid, IsA, IsB, IsC) {
		return 1
	}
	if Or(userid, IsB, IsC) {
		return 2
	}
	return 0
}
