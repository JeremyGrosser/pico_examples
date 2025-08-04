--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO;
with RP.Timer.Interrupts;
with RP.Timer;
with RP.Clock;
with Pico;

procedure Timer is
   use type RP.Timer.Time;
   Timer : RP.Timer.Interrupts.Delays;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (RP.GPIO.Output);
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
      Timer.Delay_Until (RP.Timer.Clock + RP.Timer.Ticks_Per_Second);
   end loop;
end Timer;
