--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;
with RP.PIO.WS2812;
with RP.PIO;
with RP.GPIO;
with RP.DMA;
with Pico;
with Lights;

--  Tested with a generic strip of WS2812B LEDs.
--  https://www.amazon.com/gp/product/B01CDTEJBG/?tag=synack-20
procedure Ws2812_demo is
   Strip : RP.PIO.WS2812.Strip renames Lights.Strip;

   Hue         : UInt8 := 0;
   Saturation  : constant UInt8 := 255;
   Value       : constant UInt8 := 32;
begin
   Pico.LED.Configure (RP.GPIO.Output);
   RP.DMA.Enable;
   RP.PIO.Enable (Strip.PIO);

   Strip.Initialize;
   Strip.Enable_DMA (Chan => 0);
   Strip.Clear;
   Strip.Update (Blocking => True);

   loop
      Hue := Hue + 1;
      for I in 1 .. Strip.Number_Of_LEDs loop
         Strip.Set_HSV (I, Hue + UInt8 (I mod 256), Saturation, Value);
      end loop;
      Strip.Update;

      Pico.LED.Toggle;
      delay 0.1;
   end loop;
end Ws2812_demo;
