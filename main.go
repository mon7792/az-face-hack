package main

import (
	"log"
	"net/http"
	"os"

	"example.com/api"
	"github.com/go-chi/chi"
)

func main() {
	log.Println("API STARTING...")

	//  Start the router.
	r := chi.NewRouter()
	// GET THE LIST OF ENVIRONMENT VARIABLE
	httpOpts := &api.HttpOptions{
		Router:           r,
		AzFaceHostname:   getEnv("AZ_FACE_HOST_NAME"),
		AzFaceDetectName: getEnv("AZ_FACE_DETECT_URI_NAME"),
		AzFaceVerifyName: getEnv("AZ_FACE_VERIFY_URI_NAME"),
		AzFaceKeyName:    getEnv("AZ_FACE_KEY_NAME"),
		PortNo:           getEnv("AZ_FACE_PORT_NO"),
	}

	// add the handler
	api.NewHTTPAPI(httpOpts).HandleRequests()

	log.Println("LISTENING:", httpOpts.PortNo)
	// listen.
	log.Fatal(http.ListenAndServe(":"+httpOpts.PortNo, r))
}

// getEnv returns the env var val if set else panic
func getEnv(key string) (val string) {
	val = os.Getenv(key)
	if val == "" {
		log.Panicf("env var: %s not defined", key)
	}
	return val
}
