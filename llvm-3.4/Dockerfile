# Dockerfile for LLVM 3.4, Polly, and PoCL 0.9.

# Start from an Ubuntu image.
FROM ubuntu:12.04
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > \
    /etc/apt/sources.list; \
  apt-get update
MAINTAINER Brandon Amos <bdamos@vt.edu>

# Configuration options.
ENV LLVM_SRC /usr/local/llvm
ENV POCL /usr/local/pocl
ENV CLOOG_SRC /usr/local/cloog_src
ENV LLVM_BUILD /usr/local/llvm-build

ENV CC gcc-4.6
ENV CXX g++-4.6

# 1. Download Clang, LLVM, Polly, and PoCL source files.
# 2. Install dependencies for Clang, LLVM, Polly, and PoCL.
# 3. Download and install Cloog (Polly dependency)
RUN apt-get install -y git $CC $CXX man make \
    libgmp3-dev autoconf libtool pkg-config libhwloc-dev \
    build-essential freeglut3-dev libglew-dev; \
  git clone -b release_34 http://llvm.org/git/llvm.git $LLVM_SRC; \
  git clone -b release_34 http://llvm.org/git/polly.git $LLVM_SRC/tools/polly; \
  git clone -b release_34 http://llvm.org/git/clang.git $LLVM_SRC/tools/clang; \
  $LLVM_SRC/tools/polly/utils/checkout_cloog.sh $CLOOG_SRC; \
  cd $CLOOG_SRC; \
  ./configure; \
  make; \
  make install; \
  cd ..; \
  rm -rf $CLOOG_SRC; \
  mkdir $LLVM_BUILD; \
  cd $LLVM_BUILD; \
  $LLVM_SRC/configure \
    --disable-assertions \
    --disable-bindings \
    --disable-docs \
    --enable-optimized \
    --enable-targets=host-only \
    --enable-shared; \
  make -j$(grep processor /proc/cpuinfo | wc -l) REQUIRES_RTTI=1; \
  make install

# Install PoCL
RUN git clone -b release_0_9 https://github.com/pocl/pocl.git $POCL; \
  cd $POCL; \
  ./autogen.sh; \
  ./configure --disable-icd; \
  make -j$(grep processor /proc/cpuinfo | wc -l); \
  make install

# Load dotfiles configuration for global and root users.
RUN apt-get install -y zsh vim; \
  git clone git://github.com/bamos/dotfiles.git .dotfiles; \
  cd .dotfiles; \
  git submodule init; \
  git submodule update; \
  echo n | ./bootstrap.sh \
  echo /bin/zsh | chsh; \
  su root -c 'cp /.dotfiles ~/.dotfiles -r; \
    cd ~/.dotfiles; \
    echo n | ./bootstrap.sh; \
    echo /bin/zsh | chsh root'

# Install and start an ssh service.
# https://github.com/dhrp/docker-sshd/blob/master/Dockerfile
RUN apt-get install -y openssh-server; \
  mkdir /var/run/sshd; \
  mkdir /root/.ssh; \
  wget https://github.com/bamos.keys -O /root/.ssh/authorized_keys

EXPOSE 22
CMD /usr/sbin/sshd -D
