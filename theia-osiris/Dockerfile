# https://github.com/theia-ide/theia-apps/tree/master/theia-cpp-docker

FROM node:16 as vsix

SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt update; \
    apt --assume-yes install git build-essential; \
    git clone https://github.com/WebFreak001/code-debug; \
    cd code-debug; \
    npm clean-install --no-optional; \
    npx vsce package --out /webfreak-debug.vsix


FROM registry.digitalocean.com/anubis/theia-base:python-3.10 as theia

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
  `# Install extensions` \
  code-server --user-data-dir=/opt/code-server --install-extension ms-vscode.cmake-tools; \
  code-server --user-data-dir=/opt/code-server --install-extension llvm-vs-code-extensions.vscode-clangd; \
  code-server --user-data-dir=/opt/code-server --install-extension /opt/code-server/webfreak-debug.vsix; \
  code-server --user-data-dir=/opt/code-server --install-extension 13xforever.language-x86-64-assembly; \
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
