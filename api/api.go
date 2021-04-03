package api

import (
	"bytes"
	"fmt"
	"io"
	"net/http"

	"github.com/go-chi/chi"
)

// verify response status to the client
const (
	okStatusRsp    = `{"status": "ok"}`
	nokStatusRsp   = `{"status": "nok"}`
	retryStatusRsp = `{"status": "retry"}`
)

// dummyUUIDSrcImgStore contains the list of src images from the registration flow.
var dummyUUIDSrcImgStore = map[string]string{
	"rdj-01": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/423px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg",
}

// HttpOptions docs.
type HttpOptions struct {
	Router           chi.Router
	AzFaceHostname   string
	AzFaceDetectName string
	AzFaceVerifyName string
	AzFaceKeyName    string
	PortNo           string
}

type httpAPI struct {
	r                chi.Router
	azFaceHostname   string
	azFaceDetectName string
	azFaceVerifyName string
	azFaceKeyName    string
}

// HttpAPIInterface exposes the http handlers.
type HttpAPIInterface interface {
	HandleRequests()
}

// NewHTTPAPI contructor to access the face api functionality.
func NewHTTPAPI(opt *HttpOptions) HttpAPIInterface {

	return &httpAPI{r: opt.Router,
		azFaceHostname:   opt.AzFaceHostname,
		azFaceDetectName: opt.AzFaceDetectName,
		azFaceVerifyName: opt.AzFaceVerifyName,
		azFaceKeyName:    opt.AzFaceKeyName}
}

// HandleRequests handles all the request.
func (ap *httpAPI) HandleRequests() {
	ap.r.Get("/", ap.homePage)
	ap.r.Post("/verify", ap.verifyPage)
}

// homePage docs.
func (ap *httpAPI) homePage(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "az-face-hack api")
}

// verify page.
func (ap *httpAPI) verifyPage(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseMultipartForm(32 << 20); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Header().Set("content-type", "application/json")

	// 1. get the uuid
	uuidList := r.PostForm["uuid"]

	if len(uuidList) != 1 {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("user not allowed"))
	}

	uuid := uuidList[0]
	// 2. check if the uuid exist in the cache.
	srcImgURL, exists := dummyUUIDSrcImgStore[uuid]

	// 2.a does not exist send the user not allowed response.
	if !exists {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("user not allowed"))
		return
	}

	// 3. get the verification image posted by the user.
	file, _, err := r.FormFile("file")
	defer file.Close()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	imgBuf := bytes.NewBuffer(nil)
	if _, err := io.Copy(imgBuf, file); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// 4. get the faceID for source image.
	srcFaceID, err := ap.faceDectRequestViaURL(srcImgURL)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// 5. get the faceID for compare image.
	cmpFaceID, err := ap.faceDectRequestViaFile(imgBuf.Bytes())
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// 6. verify the two faces.
	match, err := ap.faceCompareRequest(srcFaceID, cmpFaceID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	if match {
		w.Write([]byte(okStatusRsp))
		return
	}
	w.Write([]byte(nokStatusRsp))
}
