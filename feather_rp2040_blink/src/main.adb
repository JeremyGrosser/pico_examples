--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Feather_RP2040; use Feather_RP2040;
with HAL; use HAL;
with RP.Device;
with RP.Clock;
with RP.GPIO;

procedure Main is
   H, S, V : UInt8 := UInt8'Last;
begin
   RP.Clock.Initialize (XOSC_Frequency, XOSC_Startup_Delay);
   LED.Configure (RP.GPIO.Output);

   Neopixel.Initialize;
   Neopixel.Enable_DMA (0);

   RP.Device.Timer.Enable;
   loop
      LED.Toggle;
      H := H + 4;
      Neopixel.Set_HSV (1, H, S, V);
      Neopixel.Update;
      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end Main;
