# ravenscar_blink

Blinks the LED from a task using the `light_tasking_rp2040` runtime from
[community-bb-runtimes](https://github.com/damaki/community-bb-runtimes).

rp2040_hal 3.x requires a tasking runtime, so every example in this repository
can use tasks, protected objects, and `delay` statements. This one shows the
minimum needed to declare a task.
