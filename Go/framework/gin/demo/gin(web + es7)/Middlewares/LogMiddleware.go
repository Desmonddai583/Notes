package Middlewares

import (
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

func LogMiddleware() gin.HandlerFunc {
	logger := logrus.New()
	logfile, err := os.OpenFile("./mylog", os.O_RDWR|os.O_APPEND|os.O_CREATE, os.ModeAppend)
	if err != nil {
		logrus.Fatal(err)
	}
	logger.AddHook(NewEsHook())
	logger.Out = logfile
	return func(ctx *gin.Context) {
		startTime := time.Now()
		ctx.Next()
		endTime := time.Now()
		execTime := endTime.Sub(startTime) //响应时间
		requestMethod := ctx.Request.Method
		requestURI := ctx.Request.RequestURI
		statusCode := ctx.Writer.Status()
		requestIP := ctx.ClientIP()
		logger.WithField("ip", requestIP).
			WithField("status", statusCode).
			WithField("duration", execTime.Milliseconds()).
			WithField("method", requestMethod).
			WithField("url", requestURI).
			WithField("referer", ctx.Request.Referer()).
			WithField("agent", ctx.Request.Header.Get("User-Agent")).Info()
	}
}
