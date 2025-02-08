package tasks

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
)

func DeleteUnconfirmedUsers(conn *pgx.Conn) {
	// Cancel if the task takes more than 15 seconds
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	query := `DELETE FROM "Waitlist" WHERE "isVerified" = false AND "createdAt" < NOW() - INTERVAL '15 minutes'`

	ct, err := conn.Exec(ctx, query)
	if err != nil {
		fmt.Printf("Error deleting unconfirmed users: %v\n", err)
		return
	}

	if ct.RowsAffected() != 0 {
		fmt.Printf("Deleted %d unconfirmed users\n", ct.RowsAffected())
	}
}
