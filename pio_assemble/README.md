# pio_assemble

Blinks the LED with a PIO program that is assembled at compile time by `RP.PIO.Encoding`, with no external assembler.

This is an example to jump off from coding a Raspberry Pi Pico using the Ada programming language.
It is condensed from the [more complete guide here](https://pico-doc.synack.me/), and includes
configurations for [VSCode](https://code.visualstudio.com/download) and
[Vimspector](https://github.com/puremourning/vimspector) to connect to gdb using the debug interface; that's what
the 3 wires are for which you'll find across the top of the short side of a Pico, on the opposite end from the usb connector.

## Pre-requisites

You will need a Raspberry Pi Pico, and preferably also something to program it with using the debug interface. Otherwise,
you will not be able to step through the code, and will have to resort to print-statement-debugging. There are professional debug adapters like
[Segger J-Link](https://www.segger.com/products/debug-probes/j-link/), but the
[Raspberry Pi Debug Probe](https://www.raspberrypi.com/documentation/microcontrollers/debug-probe.html) or
a Raspberry Pi running OpenOCD works fine too. [Instructions for setting that up are in this video](https://www.youtube.com/watch?v=g3sGKoLafew).

To build, you need [Alire](https://alire.ada.dev/) installed. Assuming you are running Linux on x86_64, the following commands should work.

```
curl -L -O https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip
unzip alr-2.1.0-bin-x86_64-linux.zip
sudo cp bin/alr /usr/local/bin
```

Next, you need [picotool](https://github.com/raspberrypi/picotool) installed and in PATH.

## Dependencies

This project uses rp2040_hal 3.x and pico_bsp 3.x with the `embedded_rp2040` Ada runtime from
[community-bb-runtimes](https://github.com/damaki/community-bb-runtimes). The runtime provides the startup code,
linker script, clock configuration, `delay` statements, and interrupt handling. Alire downloads all of these the first
time you build.

Until version 3.0.0 of rp2040_hal and pico_bsp is released to the Alire index, `alire.toml` pins both crates to the
`3.x` branch of their git repositories.

## Building / running

To build, do `make build`. To deploy (this is the default `make` target) as well, you can do `make deploy`.
You will then need to hold the bootsel button on the pico while you plug in the USB cable and press any key to continue.
You can release the bootsel while Loading into Flash. Once it is deployed, you can replug the USB cable to start the program.

## Debugging

If using OpenOCD on a raspberry pi, for example by doing:

```
ssh tama@raspi -L3333:localhost:3333 "openocd -f interface/raspberrypi-swd.cfg -f target/rp2040.cfg"
```

If using vimspector or VSCode, you can just launch. If you need to run gdb directly instead, enter this in a terminal:

```
eval $(alr printenv)
arm-eabi-gdb bin/pio_assemble
target extended-remote localhost:3333
monitor arm semihosting enable
load
run
```

When edits have been made to the code, do `make build` again, pause the debugger, and give gdb the `load` command.
In VSCode you can enter `load` in the Debug console to do that. If using vimspector,
enter `-exec load` in the vimspector console.
