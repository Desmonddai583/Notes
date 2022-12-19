# syntax=docker/dockerfile:1

FROM golang:1.19-alpine

RUN apk add --no-cache bash

WORKDIR /app

ADD . .

RUN go mod download

RUN go build -o /restapi

EXPOSE 8081

COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

ENTRYPOINT ["./wait-for-it.sh", "mydb:3306", "--", "/restapi"]