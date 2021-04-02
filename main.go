package main

import (
	"fmt"
	"log"
	"os"

	"example.com/api"
)

func main() {
	fmt.Println("API STARTING...")
	// GET THE LIST OF ENVIRONMENT VARIABLE
	// 1. PORT NUMBER
	portNo := getEnv("PORT_NO")
	// 2. FACE API URL HOST
	// 3. FACE API DETECT URL
	// 4. FACE API VERIFY URL
	// 5. FACE API KEY
	log.Println("LISTENING:", portNo)

	api.HandleRequests()
}

// getEnv returns the env var val if set else panic
func getEnv(key string) (val string) {
	val = os.Getenv(key)
	if val == "" {
		log.Panicf("env var: %s not defined", key)
	}
	return val
}
