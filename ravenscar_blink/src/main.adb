--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO;
with Pico;

procedure Main is
begin
   Pico.LED.Configure (RP.GPIO.Output);
   loop
      Pico.LED.Toggle;
      delay 0.1;
   end loop;
end Main;
