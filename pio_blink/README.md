THIS EXAMPLE DOES NOTHING, PIO DRIVERS ARE NOT YET IMPLEMENTED

src/hello.pio needs to be assembled into gen/hello.ads before we can compile
the program. This currently requires a
[modified version of pioasm](https://github.com/JeremyGrosser/pico-sdk/tree/pioasm_ada)
in your path.

Step 1:

    gprbuild -P pioasm.gpr

Step 2:

    alr build
