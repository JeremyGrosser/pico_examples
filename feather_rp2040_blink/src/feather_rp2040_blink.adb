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
with RP.DMA;

procedure Feather_RP2040_Blink is
   H : UInt8 := UInt8'Last;
   S : constant UInt8 := UInt8'Last;
   V : constant UInt8 := 10;
begin
   RP.Clock.Initialize (XOSC_Frequency, XOSC_Startup_Delay);
   LED.Configure (RP.GPIO.Output);

   RP.DMA.Enable;
   Neopixel.PIO.Enable;

   Neopixel.Initialize;
   Neopixel.Enable_DMA (0);

   RP.Device.Timer.Enable;
   loop
      LED.Toggle;
      H := H + 1;
      Neopixel.Set_HSV (1, H, S, V);
      Neopixel.Update;
      RP.Device.Timer.Delay_Milliseconds (5);
   end loop;
end Feather_RP2040_Blink;
