# https://github.com/theia-ide/theia-apps/tree/master/theia-cpp-docker

ARG PY_VERSION=3.10
ARG BASE_IMAGE=registry.digitalocean.com/anubis/theia-base:python-${PY_VERSION}

FROM node:16 as vsix

SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt update; \
    apt --assume-yes install git build-essential; \
    git clone https://github.com/WebFreak001/code-debug; \
    cd code-debug; \
    npm clean-install --no-optional; \
    npx vsce package --out /webfreak-debug.vsix

FROM ${BASE_IMAGE} as theia
USER root

ARG USER=anubis
ARG WEBTOP=OFF

ARG USER=anubis
ARG GDB_VERSION=13.2

COPY --from=vsix /webfreak-debug.vsix /opt/code-server/webfreak-debug.vsix

USER root
RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    git make cmake strace \
    gcc-multilib g++-multilib libc6-dev \
    clangd clang-format qemu-system-i386 libgmp-dev libexpat-dev \
    nasm spim bison flex aircrack-ng airgraph-ng; \
  cd /; \
  \
  if [ "$WEBTOP" = "OFF" ]; then \
    `# Install extensions` \
    code-server --user-data-dir=/opt/code-server --install-extension ms-vscode.cmake-tools; \
    code-server --user-data-dir=/opt/code-server --install-extension llvm-vs-code-extensions.vscode-clangd; \
    code-server --user-data-dir=/opt/code-server --install-extension /opt/code-server/webfreak-debug.vsix; \
    code-server --user-data-dir=/opt/code-server --install-extension 13xforever.language-x86-64-assembly; \
  fi; \
  \
  `# We compile our own gdb like this so that it does not install the system python3` \
  wget https://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.xz; \
  tar xJf gdb-${GDB_VERSION}.tar.xz; \
  rm gdb-${GDB_VERSION}.tar.xz; \
  cd gdb-${GDB_VERSION}; \
  ./configure --with-python=python3.10 --prefix=/usr/ --with-expat; \
  make -j $(nproc); \
  make install; \
  cd ..; \
  rm -rf gdb-${GDB_VERSION}; \
  \
  `# Pwndbg` \
  echo 'set auto-load safe-path /' > /etc/anubis/skel/.gdbinit; \
  echo 'source /opt/pwndbg/gdbinit.py' >> /etc/anubis/skel/.gdbinit; \
  git clone https://github.com/pwndbg/pwndbg.git /opt/pwndbg; \
  cd /opt/pwndbg; \
  git submodule update --init --recursive; \
  pip3 install --no-cache-dir -e /opt/pwndbg; \
  \
  `# radare2` \
  cd /opt; \
  git clone https://github.com/radareorg/radare2; \
  radare2/sys/install.sh --install; \
  cd /; \
  \
  `# iaito`; \
  if [ "$WEBTOP" = "ON" ]; then \
    `# iatio` \
    apt update; \
    apt install -y \ 
      qttools5-dev qttools5-dev-tools qtbase5-dev qtchooser \
      qt5-qmake qtbase5-dev-tools libqt5svg5-dev make pkg-config build-essential; \
    cd /opt; \
    git clone https://github.com/radareorg/iaito.git; \
    cd iaito; \
    ./configure; \
    make PREFIX=/usr/local/; \
    make install PREFIX=/usr/local/; \
    cd /; \
    rm -rf /opt/iaito; \
  fi; \
  \
  `# pip install stuff` \
  pip install --no-cache-dir pwntools requests ipython scrapy; \
  \
  rm -rf /tmp/*; \
  rm -rf /usr/share/doc; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /home/node/*; \
  find / -depth \
    \( -name .cache -o -name __pycache__ -o -name '*.pyc' -o -name .git -o -name .github \) \
    -exec 'rm' '-rf' '{}' '+'; \
  chown -R ${USER}:${USER} /home/anubis

USER anubis
