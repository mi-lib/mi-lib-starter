mi-lib starter
=================================================================
Copyright (C) Tomomichi Sugihara (Zhidao) since 1998

-----------------------------------------------------------------
## [What is this?]

This starter kit includes an installer, an uninstaller and a script
to rebuild the mi-lib. They run on Ubuntu (and might run on Debian
though we did not try to do it).

mi-lib is a collection of libraries developed for the robot control
and simulation. The libraries include:
ZEDA - Elementary Data and Algorithms
ZM - a handy mathematics library
neuZ - neural network library
DZco - digital control library
Zeo - Z/Geometry and optics computation library
RoKi - Robot Kinetics library
ZX11 - a wrapper for interface library to the X Window System
LIW - Linux Wizard to assist system dependent operations on Linux
RoKi-GL - Robot Kinetics library: visualization using OpenGL

-----------------------------------------------------------------
## [Installation / Uninstallation]

### install

Edit PREFIX in config in order to specify where the libraries are
to be installed, if necessary.

Do:
   ```
   % scripts/mi-lib-install [clone/deb]
   ```
The meanings of the command-line options are as follows.
clone: Source codes of the libraries are cloned from the GitHub
     repositories.
deb: The libraries are installed from Debian packages under deb/.
If the option is omitted, source codes without Git information
are downloaded from the repositories.

### uninstall

Do:
   ```
   % scripts/mi-lib-uninstall [deb]
   ```
where deb option is valid only when the libraries are installed
from Debian packages.

-----------------------------------------------------------------
## [How to use]

Set your **PATH** and **LD\_LIBRARY\_PATH** environment variables,
if necessary. This is done by

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
