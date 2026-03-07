package main

// import (
// 	configapp "github.com/aesterial/secureguard/internal/app/config"
// 	dbclient "github.com/aesterial/secureguard/internal/infra/db"
// 	"github.com/aesterial/secureguard/internal/infra/db/repos"
// 	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
// )

// func main() {
// 	cfg := configapp.Get()
	
// 	conn, err := dbclient.New()
// 	if err != nil {
// 		return
// 	}
// 	defer conn.Pool.Close()
	
// 	usrRepo := repos.NewUserRepository(conn.Querier())
	
// }