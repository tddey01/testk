package models

import (
	"crawler-fil/utils"
	"encoding/json"
	"fmt"
	//"github.com/astaxie/beego/orm"
	"github.com/tealeg/xlsx"
	"log"
	"strings"
	"time"
)

type Func func(param map[string]interface{}) ([]map[string]string, error)     //定义函数结构
//type FuncNew func(param map[string]interface{}) (in, int32, error) //定义函数结构

//获取总数
//导出Excel
func GetExcelURL(fun Func, param map[string]interface{}) (string, error) {
	//获取参数
	sheetstr := param["sheet"].(string)
	filefield := param["filefield"].(string)
	filename := param["filename"].(string)
	title := param["title"].(string)

	//获取数据
	res, _ := fun(param)
	//数据转为[]map
	b, _ := json.Marshal(res)
	resmap := make([]map[string]interface{}, 0)
	if err := json.Unmarshal(b, &resmap); err != nil {
		fmt.Println(err)
	}
	//生成导出文件
	xlsFile := xlsx.NewFile()
	sheet, err := xlsFile.AddSheet(sheetstr)
	log.Print("XLSX:", sheet.Name, " ERROR:", err)
	if err != nil {
		//return "", err
	}

	row := sheet.AddRow()
	var cell *xlsx.Cell
	names := strings.Split(filename, ",")
	//设置列名
	for _, name := range names {
		cell = row.AddCell()
		cell.Value = name
	}

	//导出值
	fields := strings.Split(filefield, ",")
	for i := 0; i < len(resmap); i++ {
		row = sheet.AddRow()
		for _, field := range fields {
			//先转为字符串
			value := utils.Strval(resmap[i][field])
			//判断是否时间戳
			//times := strings.Split(strings.ToLower(field),"time")
			//dates := strings.Split(strings.ToLower(field),"date")
			if len(field) > 3 {
				if (strings.ToLower(field[len(field)-4:]) == "time" || strings.ToLower(field[len(field)-4:]) == "date") && len(value) == 10 {
					//时间戳转换为字符串
					value = time.Unix(int64(resmap[i][field].(float64)), 0).Format("2006/01/02 15:04:05")
				}
			}
			cell = row.AddCell()
			cell.Value = value
		}
		fmt.Println()
	}

	//time := strconv.Itoa(int(time.Now().Unix()))
	Name := title + ".xlsx"

	dirFullPath := "./"
	//err = file.IsNotExistMkDir('.')
	log.Print("DIR_FULL_PATH:", dirFullPath, " ERROR:", err)
	if err != nil {
		//return "", err
	}
	err = xlsFile.Save( dirFullPath+ Name)

	log.Print("SAVE_FILE_NAME:", Name, " ERROR:", err)
	if err != nil {
		//return "", err
	}
	return "export/" + Name, err
}