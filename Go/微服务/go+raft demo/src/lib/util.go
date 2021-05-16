package lib

//判断自己是不是leader
func IsLeader() bool {
	if string(RaftNode.Leader()) == SysConfig.Transport {
		return true
	}
	return false
}

//得到leader的http地址
func GetLeaderHttp() string {
	for _, s := range SysConfig.Servers {
		if string(s.Address) == string(RaftNode.Leader()) {
			return s.Http
		}
	}
	return ""
}
