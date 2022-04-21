# Base R Installer ![GHA Build Status](https://github.com/r-windows/r-base/actions/workflows/full-build.yml/badge.svg)

> Scripts to build R for Windows (ucrt64) using [Rtools40](https://github.com/r-windows/rtools-installer) toolchains.

This repository was used to build dailies and official releases for R 4.0.0 - 4.1.3. Sadly as of R 4.2.0, R-core has decided to go back to building the releases privately by an R-core member. Yet the current scripts and CI still work, and can be used for testing and understanding the build process.

## Downloads

Signed builds can be found under [releases](https://github.com/r-windows/r-base/releases). These installers are signed with a certified developer certificate, trusted by all Windows systems.

The daily r-devel and r-patched installers can be found as artifacts from the workflow runs. A shortcut to the latest build can be found at:

 - https://nightly.link/r-windows/r-base/workflows/full-build/master/r-devel.zip
 - https://nightly.link/r-windows/r-base/workflows/full-build/master/r-patched.zip

For the very latest svn builds, or testing patches, also checkout the r-contributor [svn-dashboard](https://contributor.r-project.org/svn-dashboard/)!

## Build requirements

To build R for Windows, you need:

 - [rtools40](https://cran.r-project.org/bin/windows/Rtools/)
 - [InnoSetup 6](https://www.jrsoftware.org/isdl.php) (only required for installer)
 - [MikTex](https://miktex.org/download) (only required for installer)

Rtools40 provides perl and all required system libraries.

## How to build yourself

Clone or [download](https://github.com/r-windows/r-base/archive/master.zip) this repository. Optionally edit [`MkRules.local.in`](MkRules.local.in) to adjust compiler flags. Now open any rtools msys2 shell from the Windows start menu.

![win10](https://user-images.githubusercontent.com/216319/73364595-1fe28080-42ab-11ea-9858-ac8c660757d6.png)

To build the latest R-devel from source, run the [`./build.sh`](build.sh) script inside the rtools40 bash shell. This will download and build a complete ucrt64 version of R-devel, but no manuals or the installer.

This is useful if you want to test a patch for base R. You can adjust the [`./build.sh`](build.sh) script to add patches.

### Building the full installer

Alternatively to build the complete installer as it would appear on CRAN, set an environment variable `build_installer` when running the build script:

```sh
# Run in rtools40 shell
export build_installer=1
./build.sh
```

This requires you have innosetup and latex installed on your machine (in addition to rtools40). The process involves building R as well as pdf manuals and finally the installer program.
