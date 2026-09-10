# RISC-V 32bit Linux

The simplest possible config + build scripts combo for building the Kernel and Buildroot.

## Usage

Building the image:

```sh
# Enter the docker environment
make docker

# (inside docker) Build the kernel + rootfs image
make
```
Starting QEMU:

```sh
make qemu
```
