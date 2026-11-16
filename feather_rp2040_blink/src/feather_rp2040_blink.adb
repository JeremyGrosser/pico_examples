--
--  Copyright 2021-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Feather_RP2040; use Feather_RP2040;
with HAL; use HAL;
with RP.GPIO;
with RP.DMA;
with RP.PIO;

procedure Feather_RP2040_Blink is
   H : UInt8 := UInt8'Last;
   S : constant UInt8 := UInt8'Last;
   V : constant UInt8 := 10;
begin
   LED.Configure (RP.GPIO.Output);

   RP.DMA.Enable;
   RP.PIO.Enable (Neopixel.PIO);

   Neopixel.Initialize;
   Neopixel.Enable_DMA (0);

   loop
      LED.Toggle;
      H := H + 1;
      Neopixel.Set_HSV (1, H, S, V);
      Neopixel.Update;
      delay 0.005;
   end loop;
end Feather_RP2040_Blink;
