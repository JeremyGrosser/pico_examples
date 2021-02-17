--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO;
with Pico;

procedure Main is
begin
   RP.GPIO.Enable;

   Pico.LED.Configure (RP.GPIO.Output);
   Pico.LED.Set;

   loop
      Pico.LED.Toggle;
      delay 0.1;
   end loop;
end Main;
