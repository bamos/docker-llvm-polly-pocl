# About.
Build LLVM 3.3, Polly, and PoCL 0.8 in an Ubuntu 12.04 Docker image.

# This downloads and installs.
+ [bamos/dotfiles](https://github.com/bamos/dotfiles)
+ [LLVM, Clang, and Polly](http://llvm.org/releases/download.html#3.3)
+ [PoCL](http://pocl.sourceforge.net/download.html)
+ Dependencies

# Using.

## Building the image.
Use docker to build the image using the Dockerfile, 2 ways.

### 1. Manually clone this repository:

```
$ git clone git@github.com:bamos/docker-llvm-polly-pocl.git
$ cd docker-llvm-polly-pocl
$ docker build -t llvm-polly-pocl .
```

### 2. Or, use docker to automatically pull the Dockerfile from here:

```
$ docker build -t llvm-polly-pocl github.com/bamos/docker-llvm-polly-pocl
```

## Running the image.

### View the built image.

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
llvm-polly-pocl     latest              4fad53ed40b8        3 minutes ago       662 MB
```

### Run the image.

```
$ docker run -i -t llvm-polly-pocl /bin/zsh
```
