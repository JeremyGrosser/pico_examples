--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;        use HAL;
with HAL.GPIO;   use HAL.GPIO;
with RP.GPIO;    use RP.GPIO;
with RP.Clock;
with Pico;
with Pico.Pimoroni.RGB_Keypad;

procedure Pimoroni_rgb_keypad is
   Count : UInt8 := 0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.Pimoroni.RGB_Keypad.Initialize;

   Pico.LED.Configure (Output);
   Pico.LED.Set;

   for P in Pico.Pimoroni.RGB_Keypad.Pad loop
      Pico.Pimoroni.RGB_Keypad.Set (P, 0, 0, 0, 0);
   end loop;
   Pico.Pimoroni.RGB_Keypad.Update;

   loop
      for P in Pico.Pimoroni.RGB_Keypad.Pad loop

         if Pico.Pimoroni.RGB_Keypad.Pressed (P) then
            Pico.Pimoroni.RGB_Keypad.Set_HSV
              (P,
               H          => Count,
               S          => 255,
               V          => 50,
               Brightness => 5);
         end if;
         Count := Count + 1;
      end loop;
      Pico.Pimoroni.RGB_Keypad.Update;
      Pico.LED.Toggle;
   end loop;
end Pimoroni_rgb_keypad;
