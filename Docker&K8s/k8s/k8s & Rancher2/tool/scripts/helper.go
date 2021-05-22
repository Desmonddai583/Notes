package scripts

import (
	"log"

	"github.com/docker/docker/client"
)

func getClient() *client.Client {
	cli, err := client.NewClient("tcp://39.105.28.235:2345", "v1.35", nil, nil)
	if err != nil {
		log.Fatal(err)
	}
	return cli
}
