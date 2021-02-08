--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.GPIO;   use HAL.GPIO;
with RP.Device;  use RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.Clock;
with Pico;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output);
   Pico.LED.Set;

   SysTick.Enable;
   loop
      Pico.LED.Toggle;
      SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
