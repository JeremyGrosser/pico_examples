# i2c_demo

This is an example to jump off from coding a Raspberry Pi Pico using the Ada programming language.
I've condensed this for my own future reading from the [more complete guide here](https://pico-doc.synack.me/), and
added configurations for [VSCode](https://code.visualstudio.com/download) and
[Vimspector](https://github.com/puremourning/vimspector) to connect to gdb using the debug interface; that's what
the 3 wires are for which you'll find across the top of the short side of a Pico, on the opposite end from the usb connector.

## Pre-requisites

You will need a raspberry pi pico, and preferably also something to program it with using the debug interface. Otherwise,
you will not be able to step through the code, and will have to resort to print-statement-debugging. I'm told there are
professional debug adapters like [Segger J-Link](https://www.segger.com/products/debug-probes/j-link/), but
a raspberry pi running OpenOCD works fine too. [Instructions for setting that up are in this video](https://www.youtube.com/watch?v=g3sGKoLafew).

To build, you need Alire installed. Assuming you are running Linux on x86_64, the following commands should work.

```
curl -L -O https://github.com/alire-project/alire/releases/download/v2.0.2/alr-2.0.2-bin-x86_64-linux.zip
unzip alr-2.0.2-bin-x86_64-linux.zip
sudo cp bin/alr /usr/local/bin
```

Next, you need [picotool](https://github.com/raspberrypi/picotool) installed and in PATH.

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
arm-eabi-gdb bin/hello_pico
target extended-remote localhost:3333
monitor arm semihosting enable
load
run
```

When edits have been made to the code, do `make build` again, pause the debugger, and give gdb the `load` command.
In VSCode you can enter `load` in the Debug console to do that. If using vimspector,
enter `-exec load` in the vimspector console.
