busybox-static-multiarch
========================

Multi-arch static busybox builder based on @multiarch crossbuild tool

[![Build Status](https://travis-ci.org/nlm/busybox-static-multiarch.svg?branch=master)](https://travis-ci.org/nlm/busybox-static-multiarch)

## Using pre-built binaries

**Recommended use**: Busybox static binaries for all the supported
targets are automatically built using Travis. This is the recommended use of
this repository.

You can download them on the
[latest release](https://github.com/nlm/busybox-static-multiarch/releases/latest/) page.

## Manually build your binaries using this repo

This is what you want to do if you prefer building your releases locally,
if you want to build a version not built by this repo or if you want to
customize your configuration.

### Requirements

- x86_64 machine
- docker
- make

### Build process

Fetch the source code from official mirror:

    # make source

Create a default config file:

    # make defconfig

*Or* use the pre-made config file:

    # make copyconfig

*Or* interactively create your own:

    # make config

Build the program, choosing a build target (see below):

    # make CROSS_TRIPLE=YOUR_BUILD_TARGET_TRIPLE build

Clean your repo

    # make clean

## Supported targets

Triple                 | AKA                                 | linux | osx | windows
-----------------------|-------------------------------------|-------|-----|--------
x86_64-linux-gnu       | **default**, linux, amd64, x86_64   |   X   |     |
arm-linux-gnueabi      | arm, armv5                          |   X   |     |
arm-linux-gnueabihf    | armhf, armv7, armv7l                |   X   |     |
aarch64-linux-gnu      | arm64, aarch64                      |   X   |     |
powerpc64le-linux-gnu  | powerpc, powerpc64, powerpc64le     |   X   |     |

(more to come !)
