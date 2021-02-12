--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.GPIO;   use HAL.GPIO;
with RP.Device;  use RP.Device;
with RP.GPIO;    use RP.GPIO;
with RP.Clock;
with Pico;
with HAL; use HAL;

with hello;

--  XXX: THIS EXAMPLE DOES NOT WORK YET

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);

   --PIO_0.Load (hello.Program_Instructions);

   SysTick.Enable;
   loop
      --  PIO_0.Put (1);
      SysTick.Delay_Milliseconds (100);
      --  PIO_0.Put (0);
      SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
