mi-lib starter
================================================================================
Copyright (C) Tomomichi Sugihara (Zhidao) since 1998

--------------------------------------------------------------------------------
# What is this?

This starter kit includes an installer, an uninstaller, and a script to rebuild
the mi-lib. They run on Ubuntu (and probably run on Debian though we did not try
it).

mi-lib is a collection of libraries developed for robot control and simulation.
The libraries include:
 - ZEDA : Elementary Data and Algorithms
 - ZM : a handy mathematics library
 - neuZ : neural network library
 - DZco : digital control library
 - Zeo : Z/Geometry and optics computation library
 - RoKi : Robot Kinetics library
 - ZX11 : a wrapper for interface library to the X Window System
 - LIW : Linux Wizard to assist system dependent operations on Linux
 - RoKi-GL : Robot Kinetics library: visualization using OpenGL
 - RoKi-FD : Robot Kinetics library: Forward Dynamics computation

--------------------------------------------------------------------------------
# Installation / Uninstallation

## install

You have two ways to install the mi-lib. Namely,
 - to specify directories to install files
 - to install files as debian packages

where "files" include shared libraries, header files, and some utility programs.
Whichever ways, you need to compile the libraries. The installer script contained
in this kit automates the process to install necessary third-party libraries and
programs via apt, make directories to install if necessary, compile the libraries,
and copy the files in either way of the above two.

### install files to specific directories

Edit PREFIX in ./config in order to specify directory to install the files, if
necessary. The default directory is ~/usr. In this case, header files and libraries
are installed under ~/usr/include and ~/usr/lib, respectively.

Do:
   ```sh
   % scripts/mi-lib-install
   ```
to download source codes from the Git repositories as zipped files, or
   ```sh
   % scripts/mi-lib-install clone
   ```
to clone the Git repositories. In the former case, the information about the
epositories is lost. It is followed by a process to compile and install the files.

### install files as debian packages

Do:
   ```sh
   % scripts/mi-lib-install deb
   ```
to make .deb packages, which will be stored under deb/, and then, install them
by dpkg. The files will be installed under /usr/ in this case.

## uninstall

Do:
   ```sh
   % scripts/mi-lib-uninstall [deb]
   ```
where deb option is valid only if the libraries are installed as debian packages.

--------------------------------------------------------------------------------
# How to use libraries

## environment variables

If you install the files as debian packages, you don't need to do anything about
the environment variables. Otherwise, set your **PATH** and **LD\_LIBRARY\_PATH**
environment variables, if necessary. This is done by
   ```sh
   % export PATH=$PATH:$PREFIX/bin
   % export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX/lib
   ```
for Bourne shell family (bash, zsh, etc.), or by:
   ```sh
   % set path = ( $path $PREFIX/bin )
   % setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PREFIX/lib
   ```
for C shell family (csh, tcsh, etc.).

## compile options

Each library has a tool *-config (for example, roki-config) to provide compile
options. 

If your code test.c uses RoKi, for example, it will be compiled into a.out by
```sh
% gcc `roki-config --cflags` test.c `roki-config -l`
```

## others

If you want to use CMake build tool, Try ["How to cmake build mi-lib"](cmakes/README_cmake.md) which is under testing.

--------------------------------------------------------------------------------
## Contact

zhidao@ieee.org
