--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.Real_Time_Clock; use HAL.Real_Time_Clock;
with Ada.Text_IO;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

--  Helper methods for formatting date and time as an ISO 8601 string
with Text_Format;

procedure Main is
   Date : RTC_Date :=
      (Day_Of_Week => Sunday,
       Year        => 21,
       Month       => June,
       Day         => 13);
   Time : RTC_Time :=
      (Hour => 12,
       Min  => 25,
       Sec  => 00);
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   Pico.LED.Configure (RP.GPIO.Output);

   RP.Device.RTC.Initialize;
   RP.Device.RTC.Set (Time, Date);

   RP.Device.Timer.Enable;
   loop
      RP.Device.RTC.Get (Time, Date);
      Ada.Text_IO.Put_Line
         (Text_Format.To_String (Time, Date));

      Pico.LED.Toggle;
      RP.Device.Timer.Delay_Milliseconds (1_000);
   end loop;
end Main;
