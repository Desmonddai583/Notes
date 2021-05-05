package main

import "locpro/jobtest"

func main() {
	jobtest.Run()
	select {}
}
