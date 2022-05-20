--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with RP.Clock;
with Pico;

with Handlers;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   --  GP9 is connected to a normally open button that connects to GND when pressed
   --  debouncing is an exercise left to the reader
   Pico.GP9.Configure (Input, Pull_Up);
   Pico.GP9.Set_Interrupt_Handler (Handlers.Toggle_LED'Access);
   Pico.GP9.Enable_Interrupt (Falling_Edge);

   Pico.LED.Configure (Output);
   Pico.LED.Set;

   loop
      null;
   end loop;
end Main;
