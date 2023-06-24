How to cmake build mi-lib
===

This is brief how to cmake build.

## Dependency

### CMake

version >= 3.26

### Compiler

- gcc
- llvm clang >= 12.0.1

### OS

- Ubuntu : >= 20.04
- Windows
  - see ["How to build on Windows (Japanese)"](README_cmake_for_MSVC_JP.md)

### Third party libraries

- [libxml2](https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home) 

&nbsp;

## cmake build

First, Clone/Download repositories mi-lib packages.  
Put them at the top directory like follows (each of '*' is repository).

```
.
├── build
├── cmakes
├── deb
├── dzco *
├── libxml2 +
├── neuz *
├── roki *
├── roki-fd *
├── roki-gl *
├── scripts 
├── test
├── zeda *
├── zeo *
└── zm *
```

Build with cmake at the top directory like follows.

```
$ mkdir build
$ cd build/
$ cmake ..
$ make
```


&nbsp;

Best Regards.

<div style="text-align: right;">EOF</div>