# https://github.com/theia-ide/theia-apps/tree/master/theia-cpp-docker

FROM node:18 as code-debug-visx

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

COPY --from=code-debug-visx /webfreak-debug.vsix /opt/code-server/webfreak-debug.vsix

USER root
RUN set -ex; \
  \
  `# Basics for c / cpp development` \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    git make cmake strace \
    gcc-multilib g++-multilib libc6-dev \
    clangd clang-format qemu-system-i386 libgmp-dev libexpat-dev \
    nasm ninja-build; \
  cd /; \
  \
  `# Install extensions` \
  code-server --user-data-dir=/opt/code-server --install-extension ms-vscode.cmake-tools; \
  code-server --user-data-dir=/opt/code-server --install-extension llvm-vs-code-extensions.vscode-clangd; \
  code-server --user-data-dir=/opt/code-server --install-extension 13xforever.language-x86-64-assembly; \
  \
  `# Install built extensions` \
  code-server --user-data-dir=/opt/code-server --install-extension /opt/code-server/webfreak-debug.vsix; \
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
  `# pwndbg` \
  echo 'set auto-load safe-path /' > /etc/anubis/skel/.gdbinit; \
  echo 'source /opt/pwndbg/gdbinit.py' >> /etc/anubis/skel/.gdbinit; \
  git clone https://github.com/pwndbg/pwndbg.git /opt/pwndbg; \
  cd /opt/pwndbg; \
  git submodule update --init --recursive; \
  pip3 install --no-cache-dir -e /opt/pwndbg; \
  \
  `# Cleanup` \
  rm -rf /tmp/*; \
  rm -rf /usr/share/doc; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /home/node/*; \
  find / -depth \
    \( -name .cache -o -name __pycache__ -o -name '*.pyc' -o -name .git -o -name .github \) \
    -exec 'rm' '-rf' '{}' '+'; \
  chown -R ${USER}:${USER} /home/anubis

COPY supervisord.conf /supervisord.conf
COPY install_extension.sh /opt/install_extension.sh
COPY settings.json /opt/code-server/User/settings.json


RUN chmod +x /opt/install_extension.sh

USER anubis
