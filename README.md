



## App services
az webapp config appsettings set --resource-group DefaultResourceGroup-WEU --name az-face-hack --settings WEBSITES_PORT=8080

## TODO.

Reset Keys.[]


az webapp config appsettings set --resource-group DefaultResourceGroup-WEU --name az-face-hack --settings WEBSITES_PORT=8080

http://geekshizzle.com/wp-content/uploads/2013/05/Robert_Downey_Jr.jpg


## Infrastructure

 docker build --no-cache -t az-face:0.0 .
 docker tag az-face:0.0 azfaceapi.azurecr.io/az-face:0.0
 docker push azfaceapi.azurecr.io/az-face:0.0