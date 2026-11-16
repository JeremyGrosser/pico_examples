--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with Pico;

with Handlers;

procedure Gpio_interrupts is
begin
   Pico.LED.Configure (Output);
   Pico.LED.Set;

   --  GP9 is connected to a normally open button that connects to GND when
   --  pressed debouncing is an exercise left to the reader
   Handlers.Button.Configure (Input, Pull_Up);

   --  See handlers.ads for the interrupt handler
   Interrupt.Enable (Handlers.Button.Pin, Interrupt.Falling);

   loop
      delay 1.0;
   end loop;
end Gpio_interrupts;
