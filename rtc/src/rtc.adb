--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.Real_Time_Clock; use HAL.Real_Time_Clock;
with Ada.Real_Time;
with RP.Device;
with RP.GPIO;
with Pico;

--  Helper methods for formatting date and time as an ISO 8601 string
with Text_Format;
with Ada.Text_IO;

procedure Rtc is
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

   use type Ada.Real_Time.Time;
   T : Ada.Real_Time.Time;
begin
   Pico.LED.Configure (RP.GPIO.Output);

   RP.Device.RTC.Configure;
   RP.Device.RTC.Set (Time, Date);

   --  Wait a couple seconds after setting the time to ensure it reads back
   --  correctly.
   T := Ada.Real_Time.Clock + Ada.Real_Time.Seconds (2);
   delay until T;

   loop
      RP.Device.RTC.Get (Time, Date);

      --  Printing over semihosting I/O is slow enough that we occasionally
      --  lose a second. If you're using this for anything important, consider
      --  using a UART for output instead.
      Ada.Text_IO.Put_Line
         (Text_Format.To_String (Time, Date));

      Pico.LED.Toggle;

      T := T + Ada.Real_Time.Seconds (1);
      delay until T;
   end loop;
end Rtc;
