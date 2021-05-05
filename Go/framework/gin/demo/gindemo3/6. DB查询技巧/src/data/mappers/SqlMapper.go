package mappers

import (
	"ginskill/src/dbs"
	"gorm.io/gorm"
)
type SqlMapper struct {
	Sql string  //SQL 语句
	Args []interface{}  //参数集合
	db *gorm.DB
}
func(this *SqlMapper) setDB(db *gorm.DB){
	this.db=db
}
func NewSqlMapper(sql string, args []interface{}) *SqlMapper {
	return &SqlMapper{Sql: sql, Args: args}
}
//查询
func(this *SqlMapper) Query() *gorm.DB{
	if this.db!=nil{
		return this.db.Raw(this.Sql,this.Args...)
	}
	return dbs.Orm.Raw(this.Sql,this.Args...)
}
//update delte insert
func(this *SqlMapper) Exec() *gorm.DB{
	if this.db!=nil{
		return this.db.Exec(this.Sql,this.Args...)
	}
	return dbs.Orm.Exec(this.Sql,this.Args...)
}
type SqlMappers []*SqlMapper
func Mappers(sqlMappers ...*SqlMapper) (list SqlMappers){
	list=sqlMappers
	return
}
func(this SqlMappers) apply(tx *gorm.DB){
	for _,sql:=range this{
		sql.setDB(tx)
	}
}
//执行事务 代码
func(this SqlMappers) Exec(f func() error) error {
	return dbs.Orm.Transaction(func(tx *gorm.DB) error {  //看gorm 的官方文档
			this.apply(tx)
			return f()
	})
}
func Mapper(sql string,args[]interface{},err error) *SqlMapper {
		if err!=nil{
			panic(err.Error())
		}
		return NewSqlMapper(sql,args)
}

