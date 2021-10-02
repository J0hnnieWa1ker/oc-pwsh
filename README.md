# oc-pwsh
- https://github.com/PowerShell/PowerShell/tree/master/docs/learning-powershell

#### create quay username variable
```
read quayusername
```
#### build this image
```
docker build -t quay.io/${quayusername}/oc-pwsh .
```
#### run this image
```
docker run -it --rm --env octoken=$octoken --env ocurl=$ocurl --name oc-pwsh quay.io/${quayusername}/oc-pwsh
```


