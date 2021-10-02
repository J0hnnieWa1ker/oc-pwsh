# oc-pwsh [![Docker Repository on Quay](https://quay.io/repository/j0hnniewa1ker/oc-pwsh/status "Docker Repository on Quay")](https://quay.io/repository/j0hnniewa1ker/oc-pwsh)
[changelog](changelog.md) 
- https://docs.openshift.com/container-platform/3.10/rest_api/index.html
- https://github.com/PowerShell/PowerShell/tree/master/docs/learning-powershell
```docker 
docker pull quay.io/j0hnniewa1ker/oc-pwsh
```
#### create oc url variable with your cluster url
```
read ocurl
```
#### create oc token variable, -s hides it and doesn't even show up in history
```
read -s octoken
```
#### run my image
```
docker run -it --rm --env octoken=$octoken --env ocurl=$ocurl --name oc-pwsh quay.io/j0hnniewa1ker/oc-pwsh
```
#### build and run your image
```
# create quay username variable
read quayusername
docker build -t quay.io/${quayusername}/oc-pwsh .
docker run -it --rm --env octoken=$octoken --env ocurl=$ocurl --name oc-pwsh quay.io/${quayusername}/oc-pwsh
```


