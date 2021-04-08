This is a port of blink to the [Adafruit Feather RP2040](https://learn.adafruit.com/adafruit-feather-rp2040-pico/overview) board. This should serve as an example of how to use the RP2040 libraries with custom boards.

The Adafruit Feather RP2040 has a different flash chip than the Pico and therefore needs different boot stage 2 code. The boot2 code can be selected with the `PICO_BSP_FLASH_CHIP` build variable or by naming the correct boot2 file in your project configuration. See the `package Linker` section in [blink_feather.gpr](blink_feather.gpr).
