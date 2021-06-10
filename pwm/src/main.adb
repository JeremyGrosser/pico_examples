--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;    use HAL;
with RP.Timer; use RP.Timer;
with RP.PWM;   use RP.PWM;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with RP;
with Pico;

with System.Machine_Code;

procedure Main is
   GP0_PWM    : constant PWM_Slice := To_PWM (Pico.GP0).Slice;
   LED_PWM    : constant PWM_Slice := To_PWM (Pico.LED).Slice;

   --  The PWM will count up at Frequency until it reaches Reload
   --  While the counter is less than Duty_Cycle, the output is High
   Frequency  : constant RP.Hertz := 1_000_000;
   Reload     : constant Period := 1_000;
   Duty_Cycle : Period := Reload / 2; --  start at 50%
   T          : Time := RP.Timer.Clock;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Device.Timer.Enable;
   RP.PWM.Initialize;

   Pico.LED.Configure
      (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.PWM);
   Pico.GP0.Configure
      (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.PWM);

   Set_Frequency (LED_PWM,
      Frequency => Frequency);
   Set_Frequency (GP0_PWM,
      Frequency => Frequency);

   Set_Interval (LED_PWM,
      Clocks => Reload);
   Set_Interval (GP0_PWM,
      Clocks => Reload);

   Enable (LED_PWM);
   Enable (GP0_PWM);

   loop
      --  Each PWM slice has two output channels. Only one is connected to the
      --  GPIO here, so setting the duty cycle of the other has no effect.
      Set_Duty_Cycle (GP0_PWM,
         Channel_A => Duty_Cycle,
         Channel_B => Duty_Cycle);
      Set_Duty_Cycle (LED_PWM,
         Channel_A => Duty_Cycle,
         Channel_B => Duty_Cycle);

      -- Increase the duty cycle by 1% every 10ms
      T := T + Milliseconds (10);
      RP.Device.Timer.Delay_Until (T);
      Duty_Cycle := (Duty_Cycle + (Reload / 100)) mod Reload;
   end loop;
end Main;
