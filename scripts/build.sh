#!/bin/sh

set -eu

DOCKER_IMAGE_NAME="riscv32-linux-build"

printout()
{
    printf "\033[1m[build.sh]\033[0m "
    echo $@
}

printerr()
{
    printf "\033[1m[build.sh]\033[0m ERR "
    echo $@
}

setup_docker_env()
{
    PREREQUISITES="
        which sed make binutils build-essential diffutils gcc g++ bash patch gzip 
        bzip2 perl tar cpio unzip rsync file bc findutils wget git ncurses-dev curl 
        git python3 vim device-tree-compiler e2fsprogs fdisk u-boot-tools fakeroot 
        dosfstools mtools gperf bison flex texinfo help2man autoconf automake libtool  
        libtool-bin gawk xz-utils libstdc++6 meson ninja-build libzstd-dev 
        python-is-python3 libssl-dev

        debootstrap qemu-user-static binfmt-support
    "

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y $PREREQUISITES
    rm -rf /var/lib/apt/lists/*
}

start_docker_env()
{
    if ! sudo docker image inspect $DOCKER_IMAGE_NAME > /dev/null 2> /dev/null; then
        printout "Building docker environment image"
        sudo docker build -t $DOCKER_IMAGE_NAME .
    else
        printout "Docker image already built"
    fi

    sudo docker run --rm -it --privileged \
        -v "$(realpath $(dirname $0)/..):/work" \
        --user "$(id -u):$(id -g)" \
        $DOCKER_IMAGE_NAME
}

unknown_command()
{
    printerr "Unknown command, exiting"
    exit 1
}

case "$1" in
    setup) setup_docker_env ;;
    docker) start_docker_env ;;
    *) unknown_command ;;
esac
