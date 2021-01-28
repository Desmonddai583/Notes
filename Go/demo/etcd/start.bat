@echo off
start "productservice1" go run p1.go -name productservice -p 8081 &
start "productservice2" go run p1.go -name productservice -p 8082

pause
