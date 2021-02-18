The ravenscar examples are broken with the current pico_bsp. The pico_bsp
project adds a linker script and some startup files to the build which conflict
with the ravenscar runtime. Making this conditional will require some changes
to alire that have not been released yet. Until then, if you need to use
ravenscar, you will need to switch to the `zfp_split` branch of pico_bsp.
