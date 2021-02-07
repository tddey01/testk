package main

import "crawler-fil/utils"

func main(){
	//closer, err := jsonrpc.NewMergeClient(context.Background(), "ws://"+lotus.Host+"/rpc/v0", "Filecoin", []interface{}{&Apis.Internal, &Apis.CommonStruct.Internal}, headers)
	//if err != nil {
	//	log.Println("connecting with lotus failed: %s", err)
	//	return nil,err
	//}
	//fmt.Println("hello")
	utils.GetTransfers()
}
