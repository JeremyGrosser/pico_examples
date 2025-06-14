--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;
with RP.PIO.WS2812;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with RP.DMA;
with Pico;

--  Tested with a generic strip of WS2812B LEDs.
--  https://www.amazon.com/gp/product/B01CDTEJBG/?tag=synack-20
procedure Ws2812_demo is
   Strip : RP.PIO.WS2812.Strip
      (Pin => Pico.GP28'Access,
       PIO => RP.Device.PIO_0'Access,
       SM  => 0,
       Number_Of_LEDs => 300);

   Hue         : UInt8 := 0;
   Saturation  : UInt8 := 255;
   Value       : UInt8 := 32;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   Pico.LED.Configure (RP.GPIO.Output);
   RP.DMA.Enable;

   Strip.Initialize;
   Strip.Enable_DMA (Chan => 0);
   Strip.Clear;
   Strip.Update (Blocking => True);

   RP.Device.Timer.Enable;
   loop
      Hue := Hue + 1;
      for I in 1 .. Strip.Number_Of_LEDs loop
         Strip.Set_HSV (I, Hue + UInt8 (I mod 256), Saturation, Value);
      end loop;
      Strip.Update;

      Pico.LED.Toggle;
      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end Ws2812_demo;
