package utils

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
)

func JsonStrToMap(e string) (map[string][]map[string]interface{}, error) {
	var dict map[string][]map[string]interface{}
	if err := json.Unmarshal([]byte(e), &dict); err == nil {
		return dict, err
	} else {
		return nil, err
	}
}
func JsonInsert(sql,json string)string{
	sql = " insert into transfers(`from`, timestamp, `to`, type, value, height) values (\"1\",2,\"3\",\"4\",5,6)"
	str := ClearBlank(sql)
	tables := strings.Split(json,`":[`)
	if len(tables) < 2{
		fmt.Println("json错误")
		return ""
	}
	var tb string
	for i:=len(tables[0]);i>0;i--{
		if tables[0][i-1:i]==`"`{
			tb = tables[0][i:len(tables[0])]
		}
	}
	if !strings.Contains(str,"insertinto"+tb){
		fmt.Println("表名不匹配！")
		return ""
	}
	return ""
}
func ClearBlank(str string)string{
	s := strings.Replace(str," ","",-1)
	str = strings.Replace(str,"\n","",-1)
	str = strings.Replace(str,"\t","",-1)
	str = strings.Replace(str,"\r\n","",-1)
	str = strings.ToLower(str)
	return s
}
func Strval(value interface{}) string {
	var key string
	if value == nil {
		return key
	}

	switch value.(type) {
	case float64:
		ft := value.(float64)
		key = strconv.FormatFloat(ft, 'f', -1, 64)
	case float32:
		ft := value.(float32)
		key = strconv.FormatFloat(float64(ft), 'f', -1, 64)
	case int:
		it := value.(int)
		key = strconv.Itoa(it)
	case uint:
		it := value.(uint)
		key = strconv.Itoa(int(it))
	case int8:
		it := value.(int8)
		key = strconv.Itoa(int(it))
	case uint8:
		it := value.(uint8)
		key = strconv.Itoa(int(it))
	case int16:
		it := value.(int16)
		key = strconv.Itoa(int(it))
	case uint16:
		it := value.(uint16)
		key = strconv.Itoa(int(it))
	case int32:
		it := value.(int32)
		key = strconv.Itoa(int(it))
	case uint32:
		it := value.(uint32)
		key = strconv.Itoa(int(it))
	case int64:
		it := value.(int64)
		key = strconv.FormatInt(it, 10)
	case uint64:
		it := value.(uint64)
		key = strconv.FormatUint(it, 10)
	case string:
		key = value.(string)
	case []byte:
		key = string(value.([]byte))
	default:
		newValue, _ := json.Marshal(value)
		key = string(newValue)
	}

	return key
}
//将sql中的占位符'？'替换成map中的参数
func SqlReplaceParames(sql string,param map[string]interface{})(string){
	fa := false
	start := 0
	sqlstr := sql
	for i:=0;i<len(sql);i++{
		if sql[i]==':'{
			start = i+1
			fa = true
		}
		if (sql[i] == '\n'|| sql[i]=='\t'||sql[i]==' '||sql[i]==','||sql[i]==')'||sql[i]=='%')&&fa{
			field := sql[start:i]
			if param[field]!=nil&&start>3{
				if sql[start-3]=='%'{
					sqlstr = strings.Replace(sqlstr,"%%:"+field+"%%",`'%%`+Strval(param[field])+`%%'`,-1)
				}else if sql[start-2]=='%' {
					sqlstr = strings.Replace(sqlstr,"%:"+field+"%",`'%`+Strval(param[field])+`%'`,-1)
				}else{
					sqlstr = strings.Replace(sqlstr,":"+field,`'`+Strval(param[field])+`'`,-1)
				}
				fa = false
			}else{
				sqlstr = field + "参数不存在!"
				return sqlstr
			}
		}

	}
	return sqlstr
}