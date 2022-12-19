package models

type DayKModel struct {
	Id        int     `gorm:"column:id" json:"id"`
	TsCode    string  `gorm:"column:ts_code" json:"ts_code"`
	TradeDate int     `gorm:"column:trade_date" json:"trade_date"`
	Open      float64 `gorm:"column:open" json:"open"`
	High      float64 `gorm:"column:high" json:"high"`
	Low       float64 `gorm:"column:low" json:"low"`
	Close     float64 `gorm:"column:close" json:"close"`
	PreClose  float64 `gorm:"column:pre_close" json:"pre_close"`
	Change    float64 `gorm:"column:open" json:"change"`
	PctChg    float64 `gorm:"column:pct_chg" json:"pct_chg"`
	Vol       float64 `gorm:"column:vol" json:"vol"`
	Amount    float64 `gorm:"column:amount" json:"amount"`
	Ma5       float64 `gorm:"column:ma5" json:"ma5"`
	Ma10      float64 `gorm:"column:ma10" json:"ma10"`
	Ma20      float64 `gorm:"column:ma20" json:"ma20"`
	Ma60      float64 `gorm:"column:ma60" json:"ma60"`
}
