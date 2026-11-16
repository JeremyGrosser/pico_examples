--
--  Copyright 2021-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  Delays are provided by the Ada runtime. The delay statements suspend the
--  calling task until the runtime's timer interrupt fires, so other tasks can
--  run and the CPU can sleep in the meantime.
--
with Ada.Real_Time; use Ada.Real_Time;
with RP.Timer;
with RP.GPIO;
with Pico;

procedure Timer is
   use type RP.Timer.Time;
   Next : Time;
begin
   Pico.LED.Configure (RP.GPIO.Output);
   Pico.LED.Set;

   loop
      --  Relative delay, in seconds
      Pico.LED.Toggle;
      delay 1.0;

      --  Absolute delay using the monotonic Ada.Real_Time clock
      Pico.LED.Toggle;
      Next := Clock + Milliseconds (1_000);
      delay until Next;

      --  RP.Timer reads the hardware timer directly (microseconds since
      --  power on) and can busy wait where a delay statement is not allowed,
      --  such as an interrupt handler.
      Pico.LED.Toggle;
      RP.Timer.Busy_Wait_Until (RP.Timer.Clock + RP.Timer.Ticks_Per_Second);
   end loop;
end Timer;
