package scripts

import (
	"context"
	"fmt"
	"log"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/go-connections/nat"
)

func StartNginx() {
	cli := getClient()
	ctx := context.Background()
	config := &container.Config{
		ExposedPorts: map[nat.Port]struct{}{
			"80/tcp": Empty{},
		},
		Image: "nginx:1.19-alpine",
	}
	hostConfig := &container.HostConfig{
		PortBindings: map[nat.Port][]nat.PortBinding{ //不需要暴露端口
			"80/tcp": []nat.PortBinding{
				nat.PortBinding{HostPort: "80"}, //宿主机的端口
			},
		},
		Binds: []string{"/home/shenyi/webconfig/nginx.conf:/etc/nginx/nginx.conf"},
	}
	ret, err := cli.ContainerCreate(ctx, config, hostConfig, nil, "nginx")
	if err != nil {
		log.Fatal(err)
	}
	err = cli.ContainerStart(ctx, ret.ID, types.ContainerStartOptions{})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Nginx容器启动成功,ID是:", ret.ID)
}
