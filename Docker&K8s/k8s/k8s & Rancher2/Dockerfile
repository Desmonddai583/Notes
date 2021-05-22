FROM golang:1.14.4-alpine3.12
RUN mkdir /src
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add build-base
ADD . /src
RUN cd /src && ls && GOPROXY=https://goproxy.cn go build -o mygo main.go  && chmod +x mygo


FROM alpine:3.12
RUN mkdir /app
COPY --from=0 /src/mygo /app
ENTRYPOINT  ["/app/mygo"]