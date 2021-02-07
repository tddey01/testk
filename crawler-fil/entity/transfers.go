package entity

type Total struct {
	TotalCount int64	`json:"totalCount"`
	Transfers []Transfers `json:"transfers"`
	Types	  []string		`json:"types"`
}
type Transfers struct{
	From string
	FromTag Tag
	Height int64
	Timestamp int64
	To string
	Type string
	Value string
	Message string
}
type Tag struct {
	name string
	signed bool
}