package api

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

type reqBody struct {
	URL string `json:"url"`
}

type respBody struct {
	FaceID string `json:"faceId"`
}

// src URL : https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/423px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg
// "Content-Type": "application/octet-stream",
// faceDectRequest via URL
func (ap *httpAPI) faceDectRequestViaURL(imgURL string) (string, error) {

	uri := "https://az-hack-face.cognitiveservices.azure.com/face/v1.0/detect"

	uri = fmt.Sprintf("%s%s", ap.azFaceHostname, ap.azFaceDetectName)

	var data reqBody
	data.URL = imgURL
	bodydata, err := json.Marshal(&data)
	if err != nil {
		return "", err
	}

	req, err := http.NewRequest(http.MethodPost, uri, bytes.NewBuffer(bodydata))
	if err != nil {
		return "", err
	}
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Ocp-Apim-Subscription-Key", "ef82d2be98d04d18b437fb64bbc1949f")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}

	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var rsp []respBody
	if err := json.Unmarshal(respBytes, &rsp); err != nil {
		return "", err
	}

	return rsp[0].FaceID, nil
}

// src URL : https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/423px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg
// "Content-Type": "application/octet-stream",
// faceDectRequestviaFile
func (ap *httpAPI) faceDectRequestViaFile(fileBytes []byte) (string, error) {

	uri := "https://az-hack-face.cognitiveservices.azure.com/face/v1.0/detect"

	req, err := http.NewRequest(http.MethodPost, uri, bytes.NewBuffer(fileBytes))
	if err != nil {
		return "", err
	}
	req.Header.Add("Content-Type", "application/octet-stream")
	req.Header.Add("Ocp-Apim-Subscription-Key", "ef82d2be98d04d18b437fb64bbc1949f")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}

	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var rsp []respBody
	if err := json.Unmarshal(respBytes, &rsp); err != nil {
		return "", err
	}

	return rsp[0].FaceID, nil
}

type reqVerifyBody struct {
	FaceID1 string `json:"faceId1"`
	FaceID2 string `json:"faceId2"`
}

type respVerifyBody struct {
	IsIdentical bool    `json:"isIdentical"`
	Confidence  float32 `json:"confidence"`
}

// {"isIdentical":true,"confidence":1.0}
func (ap *httpAPI) faceCompareRequest(srcFaceID, cmpFaceID string) (bool, error) {
	uri := "https://az-hack-face.cognitiveservices.azure.com/face/v1.0/verify"

	var data reqVerifyBody
	data.FaceID1 = srcFaceID
	data.FaceID2 = cmpFaceID
	bodydata, err := json.Marshal(&data)
	if err != nil {
		return false, err
	}

	req, err := http.NewRequest(http.MethodPost, uri, bytes.NewBuffer(bodydata))
	if err != nil {
		return false, err
	}
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Ocp-Apim-Subscription-Key", "ef82d2be98d04d18b437fb64bbc1949f")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return false, err
	}

	respBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return false, err
	}

	var rsp respVerifyBody
	if err := json.Unmarshal(respBytes, &rsp); err != nil {
		return false, err
	}

	log.Println(rsp)

	if rsp.IsIdentical || rsp.Confidence >= 0.7 {
		return true, nil
	}

	return false, nil
}
