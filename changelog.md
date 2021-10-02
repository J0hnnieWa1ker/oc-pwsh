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