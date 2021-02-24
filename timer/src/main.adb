--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.GPIO;   use HAL.GPIO;
with RP.Device;  use RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.Timer;   use RP.Timer;
with RP.Clock;
with Pico;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output);
   Pico.LED.Set;

   Timer.Enable;
   loop
      Pico.LED.Toggle;
      Timer.Delay_Microseconds (1_000_000);

      Pico.LED.Toggle;
      Timer.Delay_Milliseconds (1_000);

      Pico.LED.Toggle;
      Timer.Delay_Seconds (1);

      Pico.LED.Toggle;
      Timer.Delay_Until (Clock + Ticks_Per_Second);
   end loop;
end Main;
