# Dockerfile for LLVM 3.3, Polly, and PoCL 0.8.

# Start from an Ubuntu image.
FROM ubuntu:12.04
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
MAINTAINER Brandon Amos <bdamos@vt.edu>

# Configuration options.
ENV NUM_THREADS 4

ENV LLVM_SRC /usr/local/llvm
ENV POCL /usr/local/pocl
ENV CLOOG_SRC /usr/local/cloog_src
ENV LLVM_BUILD /usr/local/llvm_build

ENV CFE_REMOTE http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz
ENV LLVM_REMOTE http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz
ENV POLLY_REMOTE http://llvm.org/releases/3.3/polly-3.3.src.tar.gz
ENV POCL_REMOTE http://pocl.sourceforge.net/downloads/pocl-0.8.tar.gz

ENV CC gcc-4.6
ENV CXX g++-4.6

# Load dotfiles configuration for global and root users.
RUN apt-get install -y git zsh vim; \
  git clone git://github.com/bamos/dotfiles.git .dotfiles; \
  cd .dotfiles; \
  git submodule init; \
  git submodule update; \
  echo n | ./bootstrap.sh \
  HOME=/root; \
  cp /.dotfiles /root/.dotfiles -r; \
  cd /root/.dotfiles; \
  echo n | ./bootstrap.sh; \
  echo /bin/zsh | chsh; \
  echo /bin/zsh | chsh root

# Download Clang, LLVM, Polly, and PoCL source files.
RUN apt-get install -y wget tar; \
  wget -nv $CFE_REMOTE -O /tmp/cfe.tgz; \
  tar xfz /tmp/cfe.tgz -C /tmp; \
  wget -nv $LLVM_REMOTE -O /tmp/llvm.tgz; \
  tar xfz /tmp/llvm.tgz -C /tmp; \
  wget -nv $POLLY_REMOTE -O /tmp/polly.tgz; \
  tar xfz /tmp/polly.tgz -C /tmp; \
  wget -nv $POCL_REMOTE -O /tmp/pocl.tgz; \
  tar xfz /tmp/pocl.tgz -C /tmp; \
  rm /tmp/*.tgz; \
  mv /tmp/llvm-3.3.src $LLVM_SRC; \
  mv /tmp/cfe-3.3.src $LLVM_SRC/tools/clang; \
  mv /tmp/polly-3.3.src $LLVM_SRC/tools/polly; \
  mv /tmp/pocl-0.8 $POCL

# Install dependencies for Clang, LLVM, Polly, and PoCL.
RUN apt-get install -y gcc-4.6 g++-4.6 man make \
  libgmp3-dev autoconf libtool pkg-config libhwloc-dev \
  build-essential freeglut3-dev libglew-dev

# Download and install Cloog (Polly dependency)
RUN $LLVM_SRC/tools/polly/utils/checkout_cloog.sh $CLOOG_SRC; \
  cd $CLOOG_SRC; \
  ./configure; \
  make; \
  make install;

# Install Clang, LLVM, and Polly.
RUN mkdir $LLVM_BUILD; \
  cd $LLVM_BUILD; \
  $LLVM_SRC/configure --enable-shared; \
  make -j$NUM_THREADS REQUIRES_RTTI=1; \
  make install

# Install PoCL
RUN cd $POCL; \
  ./configure --disable-icd; \
  make -j$NUM_THREADS; \
  make install

# Install and start an ssh service with credentials root:llvmpollypocl.
# https://github.com/dhrp/docker-sshd/blob/master/Dockerfile
RUN apt-get install -y openssh-server; \
  mkdir /var/run/sshd; \
  echo 'root:llvmpollypocl' | chpasswd

EXPOSE 22
CMD /usr/sbin/sshd -D
