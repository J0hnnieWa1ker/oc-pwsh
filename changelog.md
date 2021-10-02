## Fri Oct  1 10:31:36 PDT 2021
Learning OpenShift and containers. I'm comfortable working zsh or bash shells but miss working in pwsh. 

### [What is PowerShell?](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1)
PowerShell is a modern command shell that includes the best features of other popular shells. ***Unlike most shells that only accept and return text, PowerShell accepts and returns .NET objects.*** 

PowerShell includes the following features:
- Robust command-line history
- Tab completion and command prediction (See about_PSReadLine)
- Supports command and parameter aliases
- Pipeline for chaining commands
- In-console help system, similar to Unix man pages
- Extensible through functions, classes, scripts, and modules
- Extensible formatting system for easy output
- Extensible type system for creating dynamic types
- Built-in support for common data formats like CSV, JSON, and XML
- Create declarative configurations and custom scripts for repeatable deployments
- Enforce configuration settings and report on configuration drift
- Deploy configuration using push or pull models

I'm not goint to bother installing it because I can just run a container from an image that already includes it.

➜  oc-pwsh git:(master) ✗ `docker run -it --rm --name oc-pwsh mcr.microsoft.com/powershell:latest`
```
Unable to find image 'mcr.microsoft.com/powershell:latest' locally
latest: Pulling from powershell
35807b77a593: Already exists 
fb18f16a9913: Already exists 
e2ee64a7dff2: Already exists 
22742c5dbe4b: Already exists 
Digest: sha256:0612c6351a0a757c0c8c3b32299270ee91e3465e002e37d1ec9f16974446d4a0
Status: Downloaded newer image for mcr.microsoft.com/powershell:latest
PowerShell 7.1.4
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.

PS /> 
```
## Fri Oct 1 11:02:23 PDT 2021
```
PS /> vi
vi: The term 'vi' is not recognized as a name of a cmdlet, function, script file, or executable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
```
- Time for a Dockerfile so I can edit files inside the container.
```
FROM mcr.microsoft.com/powershell:latest

RUN apt-get update \
    && apt-get install -y \
        vim-tiny
```

- Since I'm already playing with a custom image let's build so it's easy to push up to quay.io

```
# create quay username variable
read quayusername
```

➜  oc-pwsh git:(master) ✗ `docker run -it --rm --name oc-pwsh quay.io/${quayusername}/oc-pwsh`
```
PowerShell 7.1.4
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.

PS /> which vi
/usr/bin/vi
```
## Fri Oct 1 11:30:23 PDT 2021
```
PS /> $profile
/root/.config/powershell/Microsoft.PowerShell_profile.ps1
```
- Adding the Microsoft.PowerShell_profile.ps1

➜  oc-pwsh git:(master) ✗ `docker run -it --rm --name oc-pwsh quay.io/${quayusername}/oc-pwsh`
```
PowerShell 7.1.4
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.

hello
PS /> 
```
## Fri Oct  1 20:21:57 PDT 2021
Did a google search for `openshift powershell module` and found a lot of articles talking about using the oc cli in a powershell session but couldn't find an actual powershell module for it. No real point of using powershell that is just a wrapper around the cli tools because they just return text. I prefer Powershell because it is object oriented. 

Time to look at the OpenShift [Rest API Examples](https://docs.openshift.com/container-platform/3.10/rest_api/examples.html) odd that the documentation for 3.10 has more detail then the current versions. I'll start with the curl examples then get the calls working using `Invoke-RestMethod`

## Fri Oct  1 20:57:29 PDT 2021
starting with a $oc hash to organize configuration, list apis, and stash results in Microsoft.PowerShell_profile.ps1
```
➜  oc-pwsh git:(master) ✗ read quayusername                                                 
j0hnniewa1ker
➜  oc-pwsh git:(master) ✗ docker build -t quay.io/${quayusername}/oc-pwsh .                                                           
[+] Building 0.2s (8/8) FINISHED                                                                                                                  
 => [internal] load build definition from Dockerfile                              
 => => transferring dockerfile: 37B                                               
 => [internal] load .dockerignore                                                 
 => => transferring context: 2B                                                   
 => [internal] load metadata for mcr.microsoft.com/powershell:latest              
 => [internal] load build context                                                 
 => => transferring context: 428B                                                 
 => [1/3] FROM mcr.microsoft.com/powershell:latest                                
 => CACHED [2/3] RUN apt-get update     && apt-get install -y         vim-tiny    
 => [3/3] COPY pwsh /root/.config/powershell                                      
 => exporting to image                                                            
 => => exporting layers                                                           
 => => writing image sha256:5506774b96cfe238f0a627588f33af1fa20814f082ab8ab5334b8bd140d6a166                      
 => => naming to quay.io/j0hnniewa1ker/oc-pwsh                                    
➜  oc-pwsh git:(master) ✗ docker run -it --rm --env octoken=$octoken --env ocurl=$ocurl --name oc-pwsh quay.io/${quayusername}/oc-pwsh
PowerShell 7.1.4
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.

$oc hash to organize configuration, list apis, and stash results

Name                           Value
----                           -----
url                            https://******.us-south.containers.cloud.ibm.com:31185
headers                        {Authorization}
api                            {auth}
auth                           @{kind=User; apiVersion=user.openshift.io/v1; metadata=; identities=System.Object[]; groups=System.Object[]}

Loading personal and system profiles took 796ms.
PS /> $oc.auth

kind       : User
apiVersion : user.openshift.io/v1
metadata   : @{name=IAM#******@ibm.com; uid=*******-****-****-****-**********; resourceVersion=18691; creationTimestamp=9/20/2021 10:57:19 
             PM}
identities : {IAM:IBMid-**********}
groups     : {system:authenticated, system:authenticated:oauth}


PS /> 
```
## Fri Oct  1 23:44:07 PDT 2021
REST API calls working with `Invoke-RestMethod` and able to search for things
```zsh
➜  oc-pwsh git:(master) ✗ read quayusername                                                      
j0hnniewa1ker
➜  oc-pwsh git:(master) ✗ docker build -t quay.io/${quayusername}/oc-pwsh .
[+] Building 0.2s (8/8) FINISHED                                                                                                                  
 => [internal] load build definition from Dockerfile                                         
 => => transferring dockerfile: 37B                                                          
 => [internal] load .dockerignore                                                            
 => => transferring context: 2B                                                              
 => [internal] load metadata for mcr.microsoft.com/powershell:latest                         
 => [internal] load build context                                                            
 => => transferring context: 2.08kB                                                          
 => [1/3] FROM mcr.microsoft.com/powershell:latest                                           
 => CACHED [2/3] RUN apt-get update     && apt-get install -y         vim-tiny               
 => [3/3] COPY pwsh /root/.config/powershell                                                 
 => exporting to image                                                                       
 => => exporting layers                                                                      
 => => writing image sha256:1a42860a782e541c3e23425c6a501756395754bb4263be23d526707b9a4b7995 
 => => naming to quay.io/j0hnniewa1ker/oc-pwsh                                               
➜  oc-pwsh git:(master) ✗ docker run -it --rm --env octoken=$octoken --env ocurl=$ocurl --name oc-pwsh quay.io/${quayusername}/oc-pwsh
```
```powershell
PowerShell 7.1.4
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.

$oc hash to organize configuration, list apis, and stash results

Name  : headers
Value : {Authorization}

Name  : auth
Value : @{kind=User; apiVersion=user.openshift.io/v1; metadata=; identities=System.Object[]; groups=System.Object[]}

Name  : images
Value : {registry.redhat.io/redhat-sso-7/sso70-openshift@sha256:0155e28b6b10d6fba7144df9ce33105acbab32766836baacc67c76b900a58772, 
        registry.redhat.io/jboss-datagrid-7/datagrid73-openshift@sha256:01920073bbd480bd34e2d8e17dced64d342257fa9a263d1843edf1cc45a50a7c, 
        registry.redhat.io/jboss-eap-6/eap64-openshift@sha256:03416282b034b93614ab2af74441ce481226bcf0b0b6c614cacd1b6f008f9792, 
        quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:040f48c020420ff93b227216469f6c2971cf10fac2b0b52ea9853e88ec1964a6…}

Name  : api
Value : {secrets, pods, auth, images…}

Name  : projects
Value : {@{name=calico-system; creationTimestamp=9/20/2021 10:44:21 PM}, @{name=cat; creationTimestamp=9/22/2021 10:37:43 PM}, @{name=default; 
        creationTimestamp=9/20/2021 10:26:59 PM}, @{name=dtenfs; creationTimestamp=9/20/2021 10:57:42 PM}…}

Name  : secrets
Value : {@{name=builder-dockercfg-c5fnj; namespace=calico-system; creationTimestamp=9/20/2021 10:44:21 PM}, @{name=builder-token-7csgc; 
        namespace=calico-system; creationTimestamp=9/20/2021 10:44:21 PM}, @{name=builder-token-kx9b4; namespace=calico-system; 
        creationTimestamp=9/20/2021 10:44:21 PM}, @{name=calico-kube-controllers-dockercfg-gnwl9; namespace=calico-system; 
        creationTimestamp=9/20/2021 10:44:22 PM}…}

Name  : pods
Value : {@{name=calico-kube-controllers-b49d4775b-5htrk; creationTimestamp=9/30/2021 9:49:10 PM}, @{name=calico-node-7kvc7; 
        creationTimestamp=9/30/2021 9:49:28 PM}, @{name=calico-node-9hrx2; creationTimestamp=9/30/2021 9:49:57 PM}, @{name=calico-node-cjnc4; 
        creationTimestamp=9/30/2021 9:48:59 PM}…}

Name  : url
Value : https://c116-e.us-south.containers.cloud.ibm.com:31185

Name  : routes
Value : {@{name=example; creationTimestamp=10/1/2021 8:28:02 PM}, @{name=console; creationTimestamp=9/20/2021 10:45:01 PM}, @{name=downloads; 
        creationTimestamp=9/20/2021 10:30:12 PM}, @{name=cluster; creationTimestamp=9/20/2021 11:24:24 PM}…}


pods: 148
projects: 74
images: 294
secrets: 1271

$oc.pods -match 'tekton'

name                                              creationTimestamp
----                                              -----------------
tekton-operator-proxy-webhook-68dc6ff98f-w5rk5    9/20/2021 11:26:56 PM
tekton-pipelines-controller-6f6fc5fc95-9674f      9/20/2021 11:26:26 PM
tekton-pipelines-webhook-5ff9f7c9f7-t9nlx         9/20/2021 11:26:26 PM
tekton-triggers-controller-5c954fdb5f-rz26k       9/20/2021 11:27:14 PM
tekton-triggers-core-interceptors-7ff6c4c5b-cfbtp 9/20/2021 11:27:13 PM
tekton-triggers-webhook-55d57b9f5d-vb4vt          9/20/2021 11:27:14 PM
el-tekton-75f596cff-9nzv7                         9/29/2021 3:22:21 PM
tekton-webhook-test-29zzz                         9/20/2021 11:25:27 PM

$oc.projects -match 'model'
name                                              creationTimestamp
----                                              -----------------
tensorflow-model                                  9/29/2021 3:19:34 PM

$oc.secrets | ? {($_.namespace -match 'model') -and ($_.name -match 'git')}

name            namespace        creationTimestamp
----            ---------        -----------------
git-credentials tensorflow-model 9/29/2021 3:22:13 PM

Loading personal and system profiles took 6423ms.
PS /> 
```