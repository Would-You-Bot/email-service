package main

import (
	"fmt"
	"log"

	"github.com/Would-You-Bot/email-microservice/db"
	"github.com/Would-You-Bot/email-microservice/tasks"
	"github.com/Would-You-Bot/email-microservice/config"
	"github.com/jasonlvhit/gocron"
)

func main() {
	config.Parse()

	if err := db.Init(); err != nil {
		log.Fatalf("Error initializing database: %v", err)
	}

	gocron.Every(1).Minute().Do(func() {
		fmt.Printf("Running job - DeleteUnconfirmedUsers\n")
		tasks.DeleteUnconfirmedUsers(db.Conn)
	})

	<-gocron.Start()
}
