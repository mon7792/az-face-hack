########### Python 2.7 #############
import httplib, urllib, base64

headers = {
    # Request headers
    'Content-Type': 'application/json',
    'Ocp-Apim-Subscription-Key': 'ef82d2be98d04d18b437fb64bbc1949f',
}

params = urllib.urlencode({
    # Request parameters
    'returnFaceId': 'true',
    'returnFaceLandmarks': 'false',
    'returnFaceAttributes': 'gender',
    'recognitionModel': 'recognition_04',
    'returnRecognitionModel': 'false',
    'detectionModel': 'detection_01',
    'faceIdTimeToLive': '86400',
})

files = {"url" : open('rdj-face.jpeg','rb')}

files = {'url' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/423px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg'}

# 

# https://az-hack-face.cognitiveservices.azure.com/
try:
    print("HELLO")
    conn = httplib.HTTPSConnection('az-hack-face.cognitiveservices.azure.com')
    conn.request("POST", "/face/v1.0/detect?%s" % params, files, headers)
    response = conn.getresponse()
    data = response.read()
    print("RESULT: ",data)
    conn.close()
except Exception as e:
    # print("[Errno {0}] {1}".format(e.errno, e.strerror))
    print("ERROR",e)