package config

import (
	"os"

	"github.com/caarlos0/env/v10"
	"github.com/joho/godotenv"
)

type (
	Config struct {
		TestMode string `env:"NODE_ENV" envDefault:"development"`
		DatabaseUrl string `env:"DATABASE_URL"`
	}
)

var Conf Config

func Parse() {
	var err error
	if _, err = os.Stat(".env"); err == nil {
		err = godotenv.Load(".env")
		if err != nil {
			panic(err)
		}
	}

	if err := env.Parse(&Conf); err != nil {
		panic(err)
	}
}