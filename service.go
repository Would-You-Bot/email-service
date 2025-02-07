package main

import (
	"log"

	"github.com/Would-You-Bot/email-microservice/tasks"
	"github.com/jasonlvhit/gocron"
	"github.com/joho/godotenv"
	"github.com/Would-You-Bot/email-microservice/db"
)

func main() {
	if err := godotenv.Load(); err != nil {
    log.Fatal("Error loading .env file")
  }

	if err := db.Init(); err != nil {
		log.Fatalf("Error initializing database: %v", err)
	}

	gocron.Every(1).Minute().Do(func() {
		tasks.DeleteUnconfirmedUsers(db.Conn)
	})

	<-gocron.Start()
}
