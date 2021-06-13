--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Text_Format is

   function To_String
      (N    : Integer;
       Pad  : Positive := 1;
       Base : Positive := 10)
      return String
   is
      Translate : constant String := "0123456789ABCDEF";
      S         : String (1 .. Pad);
      Magnitude : Natural := 1;
      J         : Integer;
   begin
      for I in 1 .. Pad loop
         J := (N / Magnitude) mod Base;
         S (S'Last - (I - 1)) := Translate (Translate'First + J);
         Magnitude := Magnitude * Base;
      end loop;
      if N < 0 then
         return "-" & S;
      else
         return S;
      end if;
   end To_String;

   function To_String
      (Time        : RTC_Time;
       Date        : RTC_Date;
       Year_Offset : Integer := 2000)
      return String
   is (To_String (Integer (Date.Year) + Year_Offset, 4)
       & "-"
       & To_String (RTC_Month'Pos (Date.Month) + 1, 2)
       & "-"
       & To_String (Integer (Date.Day), 2)
       & " "
       & To_String (Integer (Time.Hour), 2)
       & ":"
       & To_String (Integer (Time.Min), 2)
       & ":"
       & To_String (Integer (Time.Sec), 2));

end Text_Format;
