# Base R Installer

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/r-windows/r-testing?svg=true)](https://ci.appveyor.com/project/jeroen/r-testing) 
[![Download](https://api.bintray.com/packages/rtools/installer/testing/images/download.svg)](https://dl.bintray.com/rtools/installer/R-testing-win.exe)

> Test build of base R with rtools40

This is an experimental build of base R with the [new toolchain](https://github.com/r-windows/rtools-installer) for testing your R packages. 
It automatically gets built and deployed every day to http://dl.bintray.com/rtools/installer/

## How to build yourself

Download this repository and run [`./build.sh`](build.sh) inside the rtools40 shell. Edit [`MkRules.local.in`](MkRules.local.in) to adjust compiler flags. 

## How to Use

This build of R has been customized to use the new rtools:

 - Automatically put rtools40 location on the `PATH`
 - Only install packages from source (CRAN binaries may not be compatible yet)
 - Packages are installed in `~/R/win-library/testing`

It should work out of the box if rtools 40 is installed, and not conflict with other R installations.
