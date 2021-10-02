# [REST API Reference](https://docs.openshift.com/container-platform/3.7/rest_api/index.html)

```
read ENDPOINT
read -s TOKEN
NAMESPACE=$(oc config current-context | cut -d/ -f1)
curl -H "Authorization: Bearer $TOKEN" "https://$ENDPOINT/apis/user.openshift.io/v1/users/~"
```
### [Get all Pods](https://docs.openshift.com/container-platform/3.7/rest_api/api/v1.Pod.html#Get-api-v1-pods)
```
curl -k \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    https://$ENDPOINT/api/v1/pods
```
### [Get all Pods in a namespace](https://docs.openshift.com/container-platform/3.7/rest_api/api/v1.Pod.html#Get-api-v1-namespaces-namespace-pods)
```
curl -k \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    https://$ENDPOINT/api/v1/namespaces/$NAMESPACE/pods
```

## [Get all Secrets](https://docs.openshift.com/container-platform/3.7/rest_api/api/v1.Secret.html#Get-api-v1-secrets)
```
curl -k \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    https://$ENDPOINT/api/v1/secrets
```
## [Get all Images](https://docs.openshift.com/container-platform/3.7/rest_api/apis-image.openshift.io/v1.Image.html#Get-apis-image.openshift.io-v1-images)
```
curl -k \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    https://$ENDPOINT/apis/image.openshift.io/v1/images
```

## [Get all Projects](https://docs.openshift.com/container-platform/3.7/rest_api/apis-project.openshift.io/v1.Project.html#Get-apis-project.openshift.io-v1-projects)

```
curl -k \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    https://$ENDPOINT/apis/project.openshift.io/v1/projects
```
## [Get all Routes](https://docs.openshift.com/container-platform/3.7/rest_api/apis-route.openshift.io/v1.Route.html#Get-apis-route.openshift.io-v1-routes)
```
curl -k \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    https://$ENDPOINT/apis/route.openshift.io/v1/routes

```
