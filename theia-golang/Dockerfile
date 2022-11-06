# https://github.com/theia-ide/theia-apps/tree/master/theia-cpp-docker

FROM registry.digitalocean.com/anubis/theia-base:python-3.10 as theia
USER root

# Step for downloading any new extensions
RUN set -ex; \
  code-server --user-data-dir=/opt/code-server --install-extension golang.Go

ENV GO_VERSION=1.19 \
  GOOS=linux \
  GOARCH=amd64 \
  GOROOT=/opt/go \
  GOPATH=/opt/go-tools
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

RUN set -ex; \
  cd /home/anubis; \
  mkdir -p $GOROOT; \
  mkdir -p $GOPATH; \
  chown -R anubis:anubis $GOROOT; \
  curl -fsSL https://storage.googleapis.com/golang/go$GO_VERSION.$GOOS-$GOARCH.tar.gz | tar -C $(dirname $GOROOT) -xzv; \
  cd /home/anubis; \
  go install github.com/uudashr/gopkgs/cmd/gopkgs@v2; \
	go install github.com/ramya-rao-a/go-outline@latest; \
	go install github.com/cweill/gotests/gotests@latest; \
	go install github.com/fatih/gomodifytags@latest; \
	go install github.com/josharian/impl@latest; \
	go install github.com/haya14busa/goplay/cmd/goplay@latest; \
	go install github.com/go-delve/delve/cmd/dlv@latest; \
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest; \
	go install golang.org/x/tools/gopls@v0.7.3; \
  echo 'export GO111MODULE=on' >> .bashrc; \
  sed -i 's/"default": "goreturns"/"default": "goformat"/' \
    /opt/theia/plugins/vscode-go/extension/package.json; \
  chown -R anubis:anubis /home/anubis

COPY supervisord.conf /supervisord.conf
USER anubis
ENV GO111MODULE=on
