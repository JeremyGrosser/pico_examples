# Raspberry Pi Pico Examples (Ada)

Each subdirectory is a standalone project which you can build using [Alire](https://alire.ada.dev/) and flash to a [Raspberry Pi Pico](https://www.raspberrypi.com/documentation/microcontrollers/pico-series.html). It is also possible to run the debugger - see the project's own README for details. You can copy whichever project is most similar to your use case to a new location and initialize your git repo there.

These examples target rp2040_hal 3.x, which uses the Ada runtimes from [community-bb-runtimes](https://github.com/damaki/community-bb-runtimes) for startup code, clock configuration, timing, and interrupt handling. Each project depends on a runtime crate such as `embedded_rp2040`. Until rp2040_hal and pico_bsp 3.0.0 are released to the Alire index, the projects pin both crates to their `3.x` branches. The `blog` directory contains historical code that accompanies a series of blog posts and is not updated.

This is a relatively new project and you may encounter bugs. Please file GitHub issues or join the discussion on [forum.ada-lang.io](https://forum.ada-lang.io/).

[Documentation](https://pico-doc.synack.me/)
