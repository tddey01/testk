package database

import (
	"fmt"
	"github.com/BurntSushi/toml"
	_ "github.com/go-sql-driver/mysql"
	"github.com/go-xorm/xorm"
	"crawler-fil/conf"
)
var Engine *xorm.Engine

const path = "conf/config.toml"

func init() {
	fmt.Println("yungo")
	var config conf.Config
	if _, err := toml.DecodeFile(path, &config); err != nil {
		// handle error\
		fmt.Println("错误:",err)
		return
	}
	NewSqlEngine(config.Mysql)
}
func NewSqlEngine(mysql *conf.MySql) {
	var err error
	Engine, err  = xorm.NewEngine("mysql", fmt.Sprintf("%s:%s@(%s)/%s?charset=utf8",mysql.Username,mysql.Password,mysql.Host,mysql.Name))
	if err!=nil{
		fmt.Println("云购错误：")
	}
	Engine.ShowSQL(true)
	return
}