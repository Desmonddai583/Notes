package main

import (
	"io/ioutil"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {

	r := gin.Default()
	r.Handle("GET", "/", func(context *gin.Context) {
		host := context.Query("host")
		if host == "" {
			context.JSON(400, gin.H{"error": "no host!"})
			return
		}
		// http://mygo
		rsp, err := http.Get("http://" + host)
		if err != nil {
			context.JSON(400, gin.H{"error": err})
		} else {
			b, err := ioutil.ReadAll(rsp.Body)
			if err != nil {
				context.JSON(400, gin.H{"error": err})
			} else {
				context.JSON(200, gin.H{"message": string(b)})
			}

		}
	})

	err := r.Run(":80")
	if err != nil {
		log.Fatal(err)
	}
}
