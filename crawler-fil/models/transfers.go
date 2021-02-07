package models

import (
	"crawler-fil/database"
	"fmt"
)

func GetTransfers(param map[string]interface{})([]map[string]string,error){
	sql := "select `from`,FROM_UNIXTIME(timestamp) timestamp,`to`,'销毁' type,value/1000000000000000000 value,height from transfers where type = 'burn'"
	m,err := database.Engine.QueryString(sql)
	if err!=nil{
		fmt.Println(err)
	}
	return m,err
}

func ExportTransfersList(){
	param := make(map[string]interface{})
	param["isexp"] = "1"
	param["sheet"] = "sheet1"
	param["filefield"] = "height,timestamp,from,to,type,value"
	param["filename"] = "高度,时间,发送方,接收方,类型,金额"
	param["title"] = "销毁列表"
	GetExcelURL(GetTransfers, param)

}