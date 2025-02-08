package db

import (
	"os"
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
)

var Conn *pgx.Conn

func Init() error {
	var err error
	Conn, err = pgx.Connect(context.Background(), os.Getenv("DATABASE_URL"))
	if err != nil {
		return fmt.Errorf("unable to connect to database: %w", err)
	}
	fmt.Println("Connected to the database")
	return nil
}
