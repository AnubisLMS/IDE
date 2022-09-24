# https://github.com/theia-ide/theia-apps/tree/master/theia-cpp-docker

FROM registry.digitalocean.com/anubis/theia-base:python-3.10 as theia

ARG GDB_VERSION=11.1

USER root
RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    git make cmake strace \
    gcc-multilib g++-multilib libc6-dev \
    clangd clang-format qemu-system-i386 libgmp-dev libexpat-dev \
    nasm; \
  cd /; \
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
  echo 'set auto-load safe-path /' > /etc/anubis/skel/.gdbinit; \
  echo 'source /opt/pwndbg/gdbinit.py' >> /etc/anubis/skel/.gdbinit; \
  git clone https://github.com/pwndbg/pwndbg.git /opt/pwndbg; \
  pip3 install --no-cache-dir -r /opt/pwndbg/requirements.txt; \
  rm -rf /tmp/*; \
  rm -rf /usr/share/doc; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /home/node/*; \
  find / -depth \
    \( -name .cache -o -name __pycache__ -o -name '*.pyc' -o -name .git -o -name .github \) \
    -exec 'rm' '-rf' '{}' '+';

USER anubis
