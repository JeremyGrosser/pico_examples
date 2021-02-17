# Raspberry Pi Pico Examples (Ada)

You will need [GNAT Community Edition ARM ELF](https://www.adacore.com/download) and [Alire](https://alire.ada.dev/) installed to build these examples.

Some dependencies are not yet included in the Alire index. You will need to clone them and point alr to them before building.

    git clone https://github.com/JeremyGrosser/rp2040_hal
    git clone https://github.com/JeremyGrosser/pico_bsp
    git clone https://github.com/JeremyGrosser/pico_examples
    cd pico_examples
    alr pin --use=../rp2040_hal rp2040_hal
    alr pin --use=../pico_bsp pico_bsp
    alr build

Ravenscar examples currently depend on an RTS that is not yet included in the GNAT Community bundle. Most of the examples use ZFP and do not need this.

    git clone https://github.com/damaki/bb-runtimes
    git checkout rpi-pico
    ./build_rts.py --output=path/to/GNAT/2020-arm-elf/arm-eabi/lib/gnat --build rpi-pico-mp
    ./build_rts.py --output=path/to/GNAT/2020-arm-elf/arm-eabi/lib/gnat --build rpi-pico-sp

If you get errors about `rts_sources.json`, you likely don't have the GNAT Community toolchain in your PATH.

Development discussion is happening on Gitter: [https://gitter.im/ada-lang/raspberrypi-pico](https://gitter.im/ada-lang/raspberrypi-pico)
