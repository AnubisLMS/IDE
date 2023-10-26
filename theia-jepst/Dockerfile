ARG PY_VERSION=3.10
ARG BASE_IMAGE=registry.digitalocean.com/anubis/theia-base:python-${PY_VERSION}

FROM ${BASE_IMAGE} as theia
USER root

ARG USER=anubis
ARG WEBTOP=OFF

# Step for downloading any new extensions
RUN set -ex; \
  if [ "${WEBTOP}" = "OFF" ]; then  \
    \
    `# Install extensions` \
    code-server --user-data-dir=/opt/code-server --install-extension ms-vscode.cmake-tools; \
    code-server --user-data-dir=/opt/code-server --install-extension llvm-vs-code-extensions.vscode-clangd; \
    code-server --user-data-dir=/opt/code-server --install-extension webfreak.debug; \
    code-server --user-data-dir=/opt/code-server --install-extension 13xforever.language-x86-64-assembly; \
    code-server --user-data-dir=/opt/code-server --install-extension haskell.haskell; \
    code-server --user-data-dir=/opt/code-server --install-extension mshr-h.veriloghdl; \
    code-server --user-data-dir=/opt/code-server --install-extension elixir-lsp.elixir-ls; \
    code-server --user-data-dir=/opt/code-server --install-extension golang.Go; \
    \
  fi

ENV GO_VERSION=1.21.0 \
  GOOS=linux \
  GOARCH=amd64 \
  GOROOT=/opt/go \
  GOPATH=/opt/go-tools
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Install extra tools
RUN set -eux; \
  `# Prolog, verilog, nasm` \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    gdb \
    ghc \
    swi-prolog \
    iverilog \
    nasm \
    hexedit \
    yosys \
    unzip; \
  \
  if [ "$WEBTOP" = "ON" ]; then apt-get install -y --no-install-recommends gtkwave; fi; \
  `# E20 utils`\
  wget https://vito.nyc/e20utils.zip; \
  unzip e20utils.zip; \
  chmod +x vea ved vem; \
  mv -t /usr/local/bin vea ved vem; \
  rm e20utils.zip; \
  `# Haskell` \
  wget https://github.com/haskell/haskell-language-server/releases/download/1.5.1/haskell-language-server-Linux-9.0.1.gz; \
  gzip -d haskell-language-server-Linux-9.0.1.gz; \
  chmod +x haskell-language-server-Linux-9.0.1; \
  mv haskell-language-server-Linux-9.0.1 /usr/local/bin/haskell-language-server; \
  \
  `# erlang / elixer` \
  wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb; \
  dpkg -i erlang-solutions_2.0_all.deb;\
  apt-get update; \
  apt-get install -y --no-install-recommends esl-erlang elixir; \
  rm -rf /tmp/*; \
  rm -rf /usr/share/doc; \
  rm -rf /var/cache/apt/*; \
  rm -rf /var/lib/apt/lists/*; \
  find / -depth \
    \( -name .cache -o -name __pycache__ -o -name '*.pyc' -o -name .git -o -name .github \) \
    -exec 'rm' '-rf' '{}' '+';

# Golang can be installed as anubis user
RUN set -eux; \
  cd /home/anubis; \
  mkdir -p $GOROOT; \
  mkdir -p $GOPATH; \
  chown -R ${USER}:${USER} $GOROOT; \
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
  rm -rf /tmp/*; \
  rm -rf /usr/share/doc; \
  rm -rf /var/cache/apt/*; \
  rm -rf /var/lib/apt/lists/*; \
  find / -depth \
    \( -name .cache -o -name __pycache__ -o -name '*.pyc' -o -name .git -o -name .github \) \
    -exec 'rm' '-rf' '{}' '+';

USER root
# Compile and install glibc 2.32 from source
RUN set -ex; \
  cd /; \
  wget https://snapshot.debian.org/archive/debian/20211205T084953Z/pool/main/g/glibc/libc6_2.32-4_amd64.deb; \
  wget https://snapshot.debian.org/archive/debian/20211205T084953Z/pool/main/g/glibc/locales_2.32-4_all.deb; \
  wget https://snapshot.debian.org/archive/debian/20211205T084953Z/pool/main/g/glibc/libc-bin_2.32-4_amd64.deb; \
  wget https://snapshot.debian.org/archive/debian/20211205T084953Z/pool/main/g/glibc/libc-l10n_2.32-4_all.deb; \
  dpkg --install libc-l10n_2.32-4_all.deb libc-bin_2.32-4_amd64.deb locales_2.32-4_all.deb libc6_2.32-4_amd64.deb; \
  rm *.deb; \
  ldconfig; \
  rm -rf /tmp/*; \
  rm -rf /usr/share/doc; \
  rm -rf /var/cache/apt/*; \
  rm -rf /var/lib/apt/lists/*; \
  find / -depth \
    \( -name .cache -o -name __pycache__ -o -name '*.pyc' -o -name .git -o -name .github \) \
    -exec 'rm' '-rf' '{}' '+'; \
  chown -R ${USER}:${USER} /home/anubis;

# Copy file over for skel initialization
COPY gopath_fix.sh /etc/anubis/init.d/gopath_fix.sh
COPY gdbinit /etc/anubis/skel/.gdbinit
COPY motd.txt /etc/motd

USER ${USER}
