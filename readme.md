# Base R Installer [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/r-windows/r-installer?branch=master)](https://ci.appveyor.com/project/jeroen/r-installer) 

> Building base R using rtools40

Scripts to build R for Windows with the new [Rtools40](https://github.com/r-windows/rtools-installer) toolchains. This version automatically gets built, checked, and deployed every day to [CRAN](https://cran.r-project.org/bin/windows/base/rdevel.html).

## Build requirements

To build R for Windows yourself, you need:

 - [rtools40](https://github.com/r-windows/docs/blob/master/rtools40.md)
 - [InnoSetup 6](https://www.jrsoftware.org/isdl.php) (only required to build the full installer)
 - [MikTex 2.9](https://cloud.r-project.org/bin/windows/Rtools/basic-miktex-2.9.7152-x64.exe)

Rtools40 provides perl and all required system libraries so we no longer need any "extsoft" file like we did in the past.

## How to build yourself

Clone or [download](https://github.com/r-windows/r-installer/archive/master.zip) this repository. Optionally edit [`MkRules.local.in`](MkRules.local.in) to adjust compiler flags. Now open any rtools msys2 shell from the Windows start menu.

![win10](https://user-images.githubusercontent.com/216319/73364595-1fe28080-42ab-11ea-9858-ac8c660757d6.png)

### Option 1: quick dev build

Run the  [`./quick-build.sh`](quick-build.sh) inside the rtools40 shell to do a quick single-architecture build. This will build a complete 64-bit version of R, but not 32-bit R and also not manuals or the installer.

This is useful if you want to test a patch for base R. Obviously you can adjust the [`./quick-build.sh`](quick-build.sh) script to add patches.

### Option 2: build full installer

Alternatively run [`./full-build.sh`](full-build.sh) to build the complete installer as it appears on CRAN. This involves building both 32 and 64 bit R, as well as pdf manuals and the installer program. This can take about 2 hours and requires you have innosetup and latex installed on your machine (in addition to rtools40).
