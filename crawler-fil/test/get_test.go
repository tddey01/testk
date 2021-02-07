package test

import (
	"crawler-fil/models"
	"crawler-fil/utils"
	"fmt"
	"testing"
)

func TestGet(t *testing.T)  {
	utils.GetTransfers()
}
func TestJs(t *testing.T){
	str := `[{"height":437779,"timestamp":1611439770,"from":"f02","fromTag":{"name":"Official","signed":false},"to":"f080468","value":"19265037272069204878","type":"reward"},{"height":437768,"timestamp":1611439440,"from":"f02","fromTag":{"name":"Official","signed":false},"to":"f080468","value":"19252852159795450092","type":"reward"}]`

	m,err:= utils.JsonStrToMap(str)
	fmt.Println(m,err)
}
func TestEx(t *testing.T){
	models.ExportTransfersList()
}