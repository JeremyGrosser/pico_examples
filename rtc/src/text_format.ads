--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.Real_Time_Clock; use HAL.Real_Time_Clock;
with HAL;

package Text_Format is

   function To_String
      (N    : Integer;
       Pad  : Positive := 1;
       Base : Positive := 10)
       return String;

   function To_String
      (Time        : RTC_Time;
       Date        : RTC_Date;
       Year_Offset : Integer := 2000)
       return String;

end Text_Format;
