# About.
Build LLVM 3.3, Polly, and PoCL 0.8 in an Ubuntu 12.04 Docker image.

# Automatic Downloads/Installs
## [bamos/dotfiles](https://github.com/bamos/dotfiles)
  (Disable if you don't want.)

## [LLVM, Clang, and Polly](http://llvm.org/releases/download.html#3.3)
+ Source: `/usr/local/llvm` and `/usr/local/llvm/tools/{clang,polly}`
+ Build: `/usr/local/llvm_build`

### Verifying Polly installation.

Show SCoPs detected by Polly on the included matrix multiple example.
See `runall.sh` in `matmul` for more examples.

```
$ cd $LLVM_SRC/tools/polly/www/experiments/matmul
$ rm *.jscop* *.exe *.l* *.s *.dot *.png
$ alias polly_opt="opt -load /usr/local/lib/LLVMPolly.so"
$ clang -S -emit-llvm matmul.c -o matmul.s
$ polly_opt -S -mem2reg -loop-simplify -polly-indvars matmul.s > matmul.preopt.ll
$ polly_opt -basicaa -polly-cloog -analyze -q matmul.preopt.ll

Pass::print not implemented for pass: 'Basic Alias Analysis (stateless AA impl)'!
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

## [PoCL](http://pocl.sourceforge.net/download.html)
+ Source and Build: `/usr/local/pocl`

### Verifying PoCL installition.

PoCL includes a test suite that can be run with the following commands.

```
$ cd $POCL
$ make check
```

# Using.

## Building the image.
Use docker to build the image using the Dockerfile, 2 ways.

### 1. Manually clone this repository:

```Bash
$ git clone git@github.com:bamos/docker-llvm-polly-pocl.git
$ cd docker-llvm-polly-pocl
$ docker build -t llvm-polly-pocl .
[...]
Successfully built 4fad53ed40b8
```

### 2. Or, use docker to automatically pull the Dockerfile from here:

```
$ docker build -t llvm-polly-pocl github.com/bamos/docker-llvm-polly-pocl
[...]
Successfully built 4fad53ed40b8
```

## Running the image.

### View the built image.

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
[...]
llvm-polly-pocl     latest              4fad53ed40b8        3 minutes ago       662 MB
[...]
```

### Run the image.

```
$ docker run -i -t llvm-polly-pocl /bin/zsh
```
