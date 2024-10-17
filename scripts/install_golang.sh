#!/bin/bash

set -e

export GO_VERSION
export GO_SRC=/usr/local/go

if [[ ! -z "$1" ]]; then
	GO_VERSION=$1
else
	GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text"|head -n1)
fi

GO_VERSION=${GO_VERSION#go}

# purge old src
if [[ -d "$GO_SRC" ]]; then
	echo "[!] Replacing old version of go found at ${GO_SRC}"
	sudo rm -rf "$GO_SRC"
	sudo rm -rf "$GOPATH"
fi

echo "[i] Downloading go version ${GO_VERSION} and extracting to ${GO_SRC}"
curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -C /usr/local -xz

(

set +e
set -x

go install github.com/cloudflare/cfssl/cmd/...@latest
go install github.com/cbednarski/hostess@latest
go install github.com/gopasspw/gopass@v1.14.9

)
