package models

type Source struct {
	SourceId   int    `gorm:"column:source_id"`
	SourceName string `gorm:"column:source_name"`
}
