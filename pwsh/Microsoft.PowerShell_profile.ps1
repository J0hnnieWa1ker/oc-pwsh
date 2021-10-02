$oc = @{
    auth=""
    url=$env:ocurl
    headers=@{Authorization="Bearer $($env:octoken)"}
    api=@{
        auth="$env:ocurl/apis/user.openshift.io/v1/users/~"
        pods="$env:ocurl/api/v1/pods"
        secrets="$env:ocurl/api/v1/secrets"
        images="$env:ocurl/apis/image.openshift.io/v1/images"
        projects="$env:ocurl/apis/project.openshift.io/v1/projects"
        routes="$env:ocurl/apis/route.openshift.io/v1/routes"
    }
    pods=""
    secrets=""
    images=""
    projects=""
    routes=""
}

$oc.auth=Invoke-RestMethod -Uri $oc.api.auth -Headers $oc.headers

function Get-Pods {
    $p=Invoke-RestMethod -Uri $oc.api.pods -Headers $oc.headers
    return $p.items.metadata | select name, creationTimestamp

}

function Get-Secrets {
    $s=Invoke-RestMethod -Uri $oc.api.secrets -Headers $oc.headers
    return $s.items.metadata | select name,namespace,creationTimestamp

}
function Get-Images {
    $i=Invoke-RestMethod -Uri $oc.api.images -Headers $oc.headers
    $h=$i | ConvertFrom-Json -AsHashtable
    return $h.items.dockerImageReference 

}
function Get-Projects {
    $p=Invoke-RestMethod -Uri $oc.api.projects -Headers $oc.headers
    return $p.items.metadata | select name, creationTimestamp

}
function Get-Routes {
    $r=Invoke-RestMethod -Uri $oc.api.routes -Headers $oc.headers
    return $r.items.metadata | select name, creationTimestamp

}

$oc.pods=Get-Pods
$oc.secrets=Get-Secrets
$oc.routes=Get-Routes
$oc.projects=Get-Projects
$oc.images=Get-Images

Write-Host -fore yellow '$oc hash to organize configuration, list apis, and stash results'
$oc | fl
Write-Host -fore yellow 'pods: ' -NoNewline
$oc.pods.count
Write-Host -fore yellow 'projects: ' -NoNewline
$oc.projects.count
Write-Host -fore yellow 'images: ' -NoNewline
$oc.images.count
Write-Host -fore yellow 'secrets: ' -NoNewline
$oc.secrets.count

$oc.pods -match 'tekton'
$oc.projects -match 'model'
$oc.secrets | ? {($_.namespace -match 'model') -and ($_.name -match 'git')}
