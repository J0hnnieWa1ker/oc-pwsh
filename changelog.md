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
Time for a Dockerfile so I can edit files inside the container.
```
FROM mcr.microsoft.com/powershell:latest

RUN apt-get update \
    && apt-get install -y \
        vim-tiny
```

Since I'm already playing with a custom image let's build so it's easy to push up to quay.io

```
# create quay username variable
read quayusername
docker build -t quay.io/${quayusername}/oc-pwsh .
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