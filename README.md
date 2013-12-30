# About.
Build LLVM 3.3, Polly, and PoCL 0.8 in an Ubuntu 12.04 Docker image.

# Automatic Downloads/Installs
## [bamos/dotfiles](https://github.com/bamos/dotfiles)

## [LLVM, Clang, and Polly](http://llvm.org/releases/download.html#3.3)
+ Source: `/usr/local/llvm` and `/usr/local/llvm/tools/{clang,polly}`
+ Build: `/usr/local/llvm_build`

## [PoCL](http://pocl.sourceforge.net/download.html)
+ Source and Build: `/usr/local/pocl`

# Environment variables
The following environment variables will be set.

```
NUM_THREADS 4
CFE_REMOTE http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz
LLVM_REMOTE http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz
POLLY_REMOTE http://llvm.org/releases/3.3/polly-3.3.src.tar.gz
POCL_REMOTE http://pocl.sourceforge.net/downloads/pocl-0.8.tar.gz
LLVM_SRC /usr/local/llvm
POCL /usr/local/pocl
CC gcc-4.6
CXX g++-4.6
CLOOG_SRC /usr/local/cloog_src
LLVM_BUILD /usr/local/llvm_build
```

# Building the image.
Use docker to build the image using the Dockerfile, 2 ways.

## 1. Manually clone this repository:

```Bash
git clone git@github.com:bamos/docker-llvm-polly-pocl.git
cd docker-llvm-polly-pocl
docker build -t llvm-polly-pocl .
```

## 2. Or, use docker to automatically pull the Dockerfile from here:

```
docker build -t llvm-polly-pocl github.com/bamos/docker-llvm-polly-pocl
```

## View the built image.

```
docker images

---

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
[...]
llvm-polly-pocl     latest              4fad53ed40b8        3 minutes ago       662 MB
[...]
```

## Run the image to start the ssh daemon.

This will start an ssh server on port 22 in the container
forwarded to 127.0.0.1:2222 in the host.
This will also forward the `$HOME` directory from the host
to `host_home` in the container, and other directories
can be synchronized similarly.

```
docker run -v $HOME:/host_home -p 127.0.0.1:2222:22 -t llvm-polly-pocl
```

## ssh into the image.

The default password is `llvmpollypocl`. Change it!

```
ssh -p 2222 root@127.0.0.1
```

# Verifying Polly installation.

Show SCoPs detected by Polly on the included matrix multiple example.
See `runall.sh` in `matmul` for more examples.

```
cd $LLVM_SRC/tools/polly/www/experiments/matmul
rm *.jscop* *.exe *.l* *.s *.dot *.png
alias polly_opt="opt -load /usr/local/lib/LLVMPolly.so"
clang -S -emit-llvm matmul.c -o matmul.s
polly_opt -S -mem2reg -loop-simplify -polly-indvars matmul.s > matmul.preopt.ll
polly_opt -basicaa -polly-cloog -analyze -q matmul.preopt.ll

---

init_array():
for (c2=0;c2<=1535;c2++) {
  for (c4=0;c4<=1535;c4++) {
    Stmt_for_body3(c2,c4);
  }
}
main():
for (c2=0;c2<=1535;c2++) {
  for (c4=0;c4<=1535;c4++) {
    Stmt_for_body3(c2,c4);
    for (c6=0;c6<=1535;c6++) {
      Stmt_for_body8(c2,c4,c6);
    }
  }
}
```

# Verifying PoCL installition.

PoCL includes a test suite that can be run with the following commands.

```
cd $POCL
make check
```
