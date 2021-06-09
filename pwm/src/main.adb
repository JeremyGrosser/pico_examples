--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;    use HAL;
with RP.PWM; use RP.PWM;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

procedure Main is
   PWM_LED    : constant PWM_Slice := To_PWM (Pico.LED).Slice;
   Reload     : constant Period := 1_000;
   Duty_Cycle : Period := 0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Device.Timer.Enable;

   Pico.LED.Configure
      (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.PWM);

   Set_Frequency (PWM_LED,
      Frequency => 1_000_000);

   --  When enabled, the PWM counts up to Clocks then toggles the output
   Set_Interval (PWM_LED,
      Clocks => Reload);

   Enable (PWM_LED);

   loop
      --  Each PWM slice has two output channels. Only one is connected to the
      --  GPIO here, so setting the duty cycle of the other has no effect.
      Set_Duty_Cycle (PWM_LED,
         Channel_A => Duty_Cycle,
         Channel_B => Duty_Cycle);

      RP.Device.Timer.Delay_Milliseconds (10);
      Duty_Cycle := (Duty_Cycle + 10) mod Reload;
   end loop;
end Main;
