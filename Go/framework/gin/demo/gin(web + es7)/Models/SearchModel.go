package Models

const (
	OrderByPriceAsc  = 1 //价格从低到高
	OrderByPriceDesc = 2 //价格从高到低
)

type SearchModel struct {
	BookName        string  `json:"book_name" binding:"omitempty"`
	BookPress       string  `json:"book_press" binding:"omitempty"`
	BookPrice1Start float32 `json:"book_price1_start" binding:"gte=0,lt=10000"`
	BookPrice1End   float32 `json:"book_price1_end" binding:"gte=0,lt=10000,mygte=BookPrice1Start"`
	OrderSet        struct {
		Score      bool `json:"score" `
		PriceOrder int  `json:"price_order" binding:"oneof=0 1 2"`
	} `json:"OrderSet" binding:"required,dive"`
	Current int `json:"current" binding:"gte=1"`
	Size    int `json:"size" binding:"oneof=10 20 50"`
}

func NewSearchModel() *SearchModel {
	return &SearchModel{}
}
