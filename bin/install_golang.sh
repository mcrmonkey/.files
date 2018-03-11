#!/bin/bash

export GO_VERSION
GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text")
export GO_SRC=/usr/local/go

# if we are passing the version
if [[ ! -z "$1" ]]; then
	GO_VERSION=$1
fi

# purge old src
if [[ -d "$GO_SRC" ]]; then
	sudo rm -rf "$GO_SRC"
	sudo rm -rf "$GOPATH"
fi

GO_VERSION=${GO_VERSION#go}

curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -xz

