default: all

BUILDROOT_DIR              := $(shell pwd)/buildroot
BUILDROOT_CONFIG           := $(shell pwd)/buildroot-config

######################################################################
# Buildroot
######################################################################

buildroot:
	make -C $(BUILDROOT_DIR) defconfig BR2_DEFCONFIG=$(BUILDROOT_CONFIG)
	make -C $(BUILDROOT_DIR) -j`nproc`

buildroot-clean:
	make -C $(BUILDROOT_DIR) clean

.PHONY: buildroot buildroot-clean

######################################################################
# QEMU
######################################################################

qemu:
	qemu-system-riscv32 -machine virt -kernel buildroot/output/images/Image -drive file=buildroot/output/images/rootfs.ext4,format=raw,if=none,id=disk -device virtio-blk-device,drive=disk -nographic -append "console=ttyS0 root=/dev/vda rw" -m 64M

.PHONY: qemu

######################################################################
# Docker
######################################################################

docker:
	./scripts/build.sh docker

.PHONY: docker
