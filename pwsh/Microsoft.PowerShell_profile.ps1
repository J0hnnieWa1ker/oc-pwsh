$oc = @{
    auth=""
    url=$env:ocurl
    headers=@{Authorization="Bearer $($env:octoken)"}
    api=@{
        auth="$env:ocurl/apis/user.openshift.io/v1/users/~"
    }
}

$oc.auth=Invoke-RestMethod -Uri $oc.api.auth -Headers $oc.headers
Write-Host -fore yellow '$oc hash to organize configuration, list apis, and stash results'
$oc