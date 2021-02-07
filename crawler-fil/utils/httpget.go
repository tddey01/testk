package utils

import (
	"crawler-fil/database"
	"crawler-fil/entity"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"time"
)


func HttpGetByte(url string)[]byte{
	resp, err := http.Get(url)
	if err != nil {
		fmt.Println("http get error", err)
		return nil
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("read error", err)
		return nil
	}
	fmt.Println(string(body))
	return body
}
func HttpGetString()string{
	resp, err := http.Get("https://filfox.info/api/v1/address/f080468/transfers?pageSize=2&page=3")
	if err != nil {
		fmt.Println("http get error", err)
		return ""
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("read error", err)
		return ""
	}
	fmt.Println(string(body))
	return string(body)
}

const (
	pageSize = 100
	count = "https://filfox.info/api/v1/address/f080468/transfers?pageSize=1&page=1"
	minerid = "f0114687"
)
func GetTransfers() {

	s := HttpGetByte(count)

	//by,_ := json.Marshal(s)
	var t entity.Total
	json.Unmarshal(s, &t)
	fmt.Println("------------------------------------------------")
	fmt.Println(t.TotalCount)
	fmt.Println("------------------------------------------------")
	fmt.Println(len(t.Transfers))
	for i:=0;i < int(t.TotalCount/pageSize);i++{
		url := "https://filfox.info/api/v1/address/"+minerid+"/transfers?pageSize="+strconv.Itoa(pageSize)+"&page="+strconv.Itoa(i)
		b := HttpGetByte(url)
		var total entity.Total
		json.Unmarshal(b, &total)

		sql := "insert into transfers_"+minerid+"(`from`,`timestamp`,`to`,message,type,value,height) values "
		param := make(map[string]interface{})
		for k,v := range total.Transfers{
			sql += "(:from,:timestamp,:to,:message,:type,:value,:height)"
			//保存参数
			param["from"] = v.From
			param["timestamp"] = v.Timestamp
			param["to"] = v.To
			param["type"] = v.Type
			param["value"] = v.Value
			param["height"] = v.Height
			param["message"] = v.Message
			sql = SqlReplaceParames(sql,param)
			if k!=len(total.Transfers)-1{
				sql += ","
			}
		}
		fmt.Println(sql)
		_, err := database.Engine.Exec(sql)
		fmt.Println("------------------------------------------------",i,err)
		time.Sleep(time.Second*30)
	}



	fmt.Println(t.Types)
}
