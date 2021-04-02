package api

import (
	"io/ioutil"
	"os"
	"testing"
)

func TestFaceDetectRequestViaURL(t *testing.T) {

	result, err := faceDectRequestViaURL("https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/423px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg")
	t.Log(err)
	t.Log(result)

}

func TestFaceVerify(t *testing.T) {

	result, err := faceCompareRequest("2c851b3a-b9c2-489d-8695-8c4c046c7ea0", "2c0d9060-f9ba-440b-87a5-d20fadba25d5")
	t.Log(err)
	t.Log(result)

}

func TestFaceDetectRequestViaFile(t *testing.T) {

	file, err := os.OpenFile("testfiles/rdj-face.jpeg", os.O_RDWR, 0644)

	defer file.Close()

	fileBytes, err := ioutil.ReadFile("testfiles/rdj-face.jpeg")
	if err != nil {
		return
	}

	result, err := faceDectRequestViaFile(fileBytes)
	t.Log(err)
	t.Log(result)

}
