--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.GPIO;   use HAL.GPIO;
with RP.GPIO;    use RP.GPIO;
with RP.SysTick;
with RP.Device;
with RP.Clock;
with Pico;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output);
   Pico.LED.Set;

   RP.SysTick.Enable;
   loop
      Pico.LED.Toggle;
      RP.Device.SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
