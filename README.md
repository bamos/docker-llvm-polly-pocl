# About.
Build LLVM 3.3, Polly, and PoCL 0.8 in an Ubuntu Docker image.

# This downloads and installs.
+ [bamos/dotfiles](https://github.com/bamos/dotfiles)
+ [LLVM, Clang, and Polly](http://llvm.org/releases/download.html#3.3)
+ [PoCL](http://pocl.sourceforge.net/download.html)
+ Dependencies

# Using.
Use docker to build the image from the Dockerfile.

```
$ docker build -t llvm-polly-pocl .
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
llvm-polly-pocl     latest              4fad53ed40b8        3 minutes ago       662 MB
$ docker run -i -t llvm-polly-pocl /bin/zsh
```
