--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.Real_Time_Clock; use HAL.Real_Time_Clock;
with RP.Timer; use RP.Timer;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

--  Helper methods for formatting date and time as an ISO 8601 string
with Text_Format;
with Ada.Text_IO;

procedure Main is
   --  Try to trigger a Y2K bug
   Date : RTC_Date :=
      (Day_Of_Week => Sunday,
       Year        => 99,
       Month       => December,
       Day         => 31);
   Time : RTC_Time :=
      (Hour => 23,
       Min  => 59,
       Sec  => 50);

   T : RP.Timer.Time;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Device.Timer.Enable;

   Pico.LED.Configure (RP.GPIO.Output);

   RP.Device.RTC.Initialize;
   RP.Device.RTC.Set (Time, Date);

   --  Wait a couple seconds after setting the time to ensure it reads back
   --  correctly.
   T := RP.Timer.Clock + Ticks_Per_Second * 2;
   RP.Device.Timer.Delay_Until (T);

   loop
      RP.Device.RTC.Get (Time, Date);
      Ada.Text_IO.Put_Line
         (Text_Format.To_String (Time, Date));

      Pico.LED.Toggle;

      T := T + Ticks_Per_Second;
      RP.Device.Timer.Delay_Until (T);
   end loop;
end Main;
