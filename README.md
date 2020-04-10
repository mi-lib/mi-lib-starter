milib starter
=================================================================
Copyright (C) Tomomichi Sugihara (Zhidao) since 1998

-----------------------------------------------------------------
## [What is this?]

This starter kit includes an installer, an uninstaller and a script
for a rebuild of milib. They run on Ubuntu (might run on Debian
though the author did not try to do it).

milib is a collection of libraries developed for the robot control
and simulation. The libraries include:
ZEDA - Elementary Data and Algorithms
ZM - a handy mathematics library
Zeo - Z/Geometry and optics computation library
DZco - digital control library
RoKi - Robot Kinetics library
ZX11 - a wrapper for interface library to the X Window System
LIW - Linux Wizard to assist system dependent operations on Linux
RoKi-GL - Robot Kinetics library: visualization using OpenGL

-----------------------------------------------------------------
## [Installation / Uninstallation]

### install

Do:
   ```
   % milib-install <dir>
   ```
where <dir> is a name of directory where the ibraries and tools
re installed. After completion, <dir>/bin, <dir>/include, and
<dir>/lib are generated.
If <dir> is omitted, the libraries and tools are installed under
/bin.

### uninstall

Do:
   ```
   % milib-uninstall
   ```

-----------------------------------------------------------------
## [How to use]

Set your **PATH** and **LD\_LIBRARY\_PATH** environment variables.
This is done by:

   ```
   % export PATH=$PATH:$PREFIX/bin
   % export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX/lib
   ```

for Bourne shell family (bash, zsh, etc.), or by:

   ```
   % set path = ( $path $PREFIX/bin )
   % setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PREFIX/lib
   ```

for C shell family (csh, tcsh, etc.).

-----------------------------------------------------------------
## [Contact]

zhidao@ieee.org
