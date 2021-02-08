--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Text_IO; use Ada.Text_IO;
with RP.Device;   use RP.Device;
with RP.ADC;      use RP.ADC;
with RP.Clock;
with Pico;

procedure Main is
   VSYS : Microvolts;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.ADC);
   RP.ADC.Configure (0);
   RP.ADC.Configure (Pico.VSYS_DIV_3);
   RP.ADC.Configure (Temperature_Sensor);

   SysTick.Enable;
   loop
      VSYS := Read_Microvolts (Pico.VSYS_DIV_3) * 3;
      Put_Line ("Channel 0:  " & Read_Microvolts (0)'Image & "μv");
      Put_Line ("VSYS:       " & VSYS'Image & "μv");
      Put_Line ("Temperature:" & Temperature'Image & "°C");
      SysTick.Delay_Milliseconds (1000);
   end loop;
end Main;
