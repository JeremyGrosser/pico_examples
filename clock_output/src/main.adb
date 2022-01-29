--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  This example outputs a 10 MHz clock driven by clk_sys on GPOUT0 (Pico.GP21)
--
with RP.Clock; use RP.Clock;
with RP.GPIO;  use RP.GPIO;
with Pico;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   Pico.LED.Configure (Output);
   Pico.LED.Set;

   Pico.GP21.Configure (Output, Pull_Up, RP.GPIO.CLOCK, Slew_Fast => True);
   RP.Clock.Set_Source (GPOUT0, SYS);
   RP.Clock.Set_Divider (GPOUT0, 12.5);
   RP.Clock.Enable (GPOUT0);

   loop
      null;
   end loop;
end Main;
