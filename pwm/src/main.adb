--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.GPIO; use HAL.GPIO;
with RP.Device; use RP.Device;
with RP.Clock; use RP.Clock;
with RP.GPIO; use RP.GPIO;
with RP.PWM; use RP.PWM;
with RP; use RP;
with Pico;

procedure Main is
   use type RP.PWM.Period;
   PWM15 : constant PWM_Point := To_PWM (Pico.GP15);
   Duty_Cycle : Period := 0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Clock.Enable (PERI);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output, Pull_Up);
   Pico.GP15.Configure (Analog, Floating, RP.GPIO.PWM);
   Set_Phase_Correction (PWM15.Slice, True);
   Set_Clock_Divider (PWM15.Slice, Clock_Divider (Frequency (SYS) / 10_000_000));
   Set_Interval (PWM15.Slice, 10);
   Set_Duty_Cycle (PWM15, Duty_Cycle);
   Enable (PWM15.Slice);

   SysTick.Enable;
   loop
      SysTick.Delay_Milliseconds (100);
      Duty_Cycle := (Duty_Cycle + 1) mod 10;
      Set_Duty_Cycle (PWM15, Duty_Cycle);
      Pico.LED.Toggle;
   end loop;
end Main;
