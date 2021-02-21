# Raspberry Pi Pico Examples (Ada)

This is a relatively new project and you may encounter bugs. Please file GitHub issues or join the development discussion on Gitter: [https://gitter.im/ada-lang/raspberrypi-pico](https://gitter.im/ada-lang/raspberrypi-pico).

## Getting started

### Docker

If you are on a x86_64 machine and have [Docker](https://www.docker.com/products/docker-desktop) installed, you can use the [ada-builder](https://github.com/JeremyGrosser/ada-builder) environment with the included build script.

    ./build.sh

### The hard way

You will need [GNAT Community Edition ARM ELF](https://www.adacore.com/download) and [Alire](https://alire.ada.dev/) installed to build these examples.

Some dependencies are not yet included in the Alire index. You will need to clone them and point alr to them before building.

    git clone https://github.com/JeremyGrosser/rp2040_hal
    git clone https://github.com/JeremyGrosser/pico_bsp
    git clone https://github.com/JeremyGrosser/pico_examples
    cd pico_examples
    alr pin --use=../rp2040_hal rp2040_hal
    alr pin --use=../pico_bsp pico_bsp
    alr build

## Ravenscar

Ravenscar examples currently depend on an RTS that is not included in the GNAT Community bundle. Most of the examples use ZFP and do not need this. Further, the pico_bsp package cannot currently be built using the ravenscar RTS as the linker scripts and startup code included in the BSP conflict with those provided by bb-runtimes. This probably won't work, but if you'd like to try anyway...

    git clone https://github.com/damaki/bb-runtimes
    git checkout rpi-pico
    ./build_rts.py --output=path/to/GNAT/2020-arm-elf/arm-eabi/lib/gnat --build rpi-pico-mp
    ./build_rts.py --output=path/to/GNAT/2020-arm-elf/arm-eabi/lib/gnat --build rpi-pico-sp

If you get errors about `rts_sources.json`, you likely don't have the GNAT Community toolchain in your PATH.
