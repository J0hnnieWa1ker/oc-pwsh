FROM mcr.microsoft.com/powershell:latest

RUN apt-get update \
    && apt-get install -y \
        vim-tiny

COPY pwsh /root/.config/powershell
