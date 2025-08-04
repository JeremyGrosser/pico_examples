--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;
with RP.Timer; use RP.Timer;
with RP.PWM; use RP.PWM;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

procedure Pwm is
   GP0 : constant PWM_Point := To_PWM (Pico.GP0);
   LED : constant PWM_Point := To_PWM (Pico.LED);

   --  The PWM will count up at Frequency until it reaches Reload
   --  While the counter is less than Duty_Cycle, the output is High
   Frequency  : constant RP.Hertz := 1_000_000;
   Reload     : constant Period := 1_000;
   Duty_Cycle : Period := Reload / 2; --  start at 50%
   T          : RP.Timer.Time := RP.Timer.Clock;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Device.Timer.Enable;
   RP.PWM.Initialize;

   Pico.LED.Configure
      (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.PWM);
   Pico.GP0.Configure
      (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.PWM);

   Set_Frequency (LED.Slice, Frequency);
   Set_Interval (LED.Slice, Reload);
   Enable (LED.Slice);

   Set_Frequency (GP0.Slice, Frequency);
   Set_Interval (GP0.Slice, Reload);
   Enable (GP0.Slice);

   loop
      Set_Duty_Cycle (GP0.Slice, GP0.Channel, Duty_Cycle);
      Set_Duty_Cycle (LED.Slice, LED.Channel, Duty_Cycle);

      --  Increase the duty cycle by 1% every 10ms
      Duty_Cycle := (Duty_Cycle + (Reload / 100)) mod Reload;

      T := T + Milliseconds (10);
      RP.Device.Timer.Delay_Until (T);
   end loop;
end Pwm;
