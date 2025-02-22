package config

import (
	"github.com/caarlos0/env/v10"
)

type (
	Config struct {
		TestMode string `env:"NODE_ENV" envDefault:"development"`
		DatabaseUrl string `env:"DATABASE_URL"`
	}
)

var Conf Config

func Parse() {
	if err := env.Parse(&Conf); err != nil {
		panic(err)
	}
}
