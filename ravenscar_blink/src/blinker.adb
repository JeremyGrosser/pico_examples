--
--  Copyright 2021-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Real_Time; use Ada.Real_Time;
with RP.GPIO;
with Pico;

package body Blinker is

   task body Blink is
      Next : Time := Clock;
   begin
      Pico.LED.Configure (RP.GPIO.Output);
      loop
         Pico.LED.Toggle;
         Next := Next + Milliseconds (100);
         delay until Next;
      end loop;
   end Blink;

end Blinker;
