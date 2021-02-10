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
   PWM_LED : constant PWM_Point := To_PWM (Pico.LED);
   Duty_Cycle : Period := 0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Clock.Enable (PERI);
   RP.GPIO.Enable;

   Pico.LED.Configure (Analog, Floating, RP.GPIO.PWM);
   Set_Phase_Correction (PWM_LED.Slice, True);
   Set_Clock_Divider (PWM_LED.Slice, Clock_Divider (Frequency (SYS) / 10_000_000));
   Set_Interval (PWM_LED.Slice, 100);
   Set_Duty_Cycle (PWM_LED, Duty_Cycle);
   Enable (PWM_LED.Slice);

   SysTick.Enable;
   loop
      SysTick.Delay_Milliseconds (10);
      Duty_Cycle := (Duty_Cycle + 1) mod 100;
      Set_Duty_Cycle (PWM_LED, Duty_Cycle);
   end loop;
end Main;
