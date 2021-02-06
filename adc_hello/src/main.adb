--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Text_IO; use Ada.Text_IO;
with HAL; use HAL;
with RP.SysTick;
with RP.Device;
with RP.Clock;
with RP.ADC;
with Pico;

procedure Main is
   type Microvolts is new Integer;
   VREF   : constant Microvolts := 3_300_000;
   Counts : RP.ADC.Analog_Value;
   Result : Microvolts;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.ADC);
   RP.ADC.Configure (Channel => 0);

   RP.SysTick.Enable;
   loop
      Counts := RP.ADC.Read (Channel => 0);
      if Counts = 0 then
         Result := 0;
      else
         Result := (VREF / Microvolts (RP.ADC.Analog_Value'Last)) * Microvolts (Counts);
      end if;
      Put_Line ("Raw value:" & Counts'Image & "," & Result'Image & "μv");

      RP.Device.SysTick.Delay_Milliseconds (1000);
   end loop;
end Main;
