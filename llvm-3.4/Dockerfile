# Dockerfile for LLVM 3.4, Polly, and PoCL 0.9.

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

ENV CC gcc-4.6
ENV CXX g++-4.6

# Download Clang, LLVM, Polly, and PoCL source files.
RUN git clone http://llvm.org/git/llvm.git $LLVM_SRC; \
  git clone http://llvm.org/git/polly.git $LLVM_SRC/tools/polly; \
  git clone http://llvm.org/git/clang.git $LLVM_SRC/tools/clang

# Install dependencies for Clang, LLVM, Polly, and PoCL.
RUN apt-get install -y $CC $CXX man make \
  libgmp3-dev autoconf libtool pkg-config libhwloc-dev \
  build-essential freeglut3-dev libglew-dev

# Download and install Cloog (Polly dependency)
RUN apt-get install -y git; \
  $LLVM_SRC/tools/polly/utils/checkout_cloog.sh $CLOOG_SRC; \
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
