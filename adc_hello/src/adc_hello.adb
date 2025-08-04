--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Text_IO; use Ada.Text_IO;
with RP.Device;   use RP.Device;
with RP.GPIO;     use RP.GPIO;
with RP.ADC;      use RP.ADC;
with RP.Clock;
with Pico;

procedure Adc_hello is
   VSYS : Microvolts;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);

   --  The Pico's power regulator dynamically adjusts it's switching frequency
   --  based on load. This introduces noise that can affect ADC readings. The
   --  Pico datasheet recommends setting Power Save pin high while performing
   --  ADC measurements to minimize this noise, at tne expense of higher power
   --  consumption.
   Pico.SMPS_PS.Configure (Output, Pull_Up);
   Pico.SMPS_PS.Clear;

   RP.ADC.Enable;
   RP.ADC.Configure (0);
   RP.ADC.Configure (Pico.VSYS_DIV_3);

   RP.Device.Timer.Enable;
   loop
      Pico.SMPS_PS.Set;
      VSYS := RP.ADC.Read_Microvolts (Pico.VSYS_DIV_3) * 3;
      Put_Line ("Channel 0:  " & RP.ADC.Read_Microvolts (0)'Image & " uv");
      Put_Line ("VSYS:       " & VSYS'Image & " uv");
      Put_Line ("Temperature:" & RP.ADC.Temperature'Image & " C");
      Pico.SMPS_PS.Clear;
      RP.Device.Timer.Delay_Milliseconds (1000);
   end loop;
end Adc_hello;
