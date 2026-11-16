--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Synchronous_Task_Control; use Ada.Synchronous_Task_Control;
with Ada.Real_Time; use Ada.Real_Time;
with RP.GPIO;
with Pico;

package body LED_Control is

   Signal : Suspension_Object;

   procedure Initialize is
   begin
      Pico.LED.Configure (RP.GPIO.Output);
   end Initialize;

   procedure Run is
      T : Time := Clock;
   begin
      loop
         T := T + Milliseconds (1_000);
         delay until T;
         Set_True (Signal);
      end loop;
   end Run;

   task body Blinker is
   begin
      loop
         Suspend_Until_True (Signal);
         Pico.LED.Toggle;
      end loop;
   end Blinker;

end LED_Control;
