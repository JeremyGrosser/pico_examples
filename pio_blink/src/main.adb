--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Device; use RP.Device;
with RP.PIO;    use RP.PIO;
with RP.GPIO;   use RP.GPIO;
with HAL;       use HAL;
with RP.Clock;
with Pico;
with Hello;

procedure Main is
   SM : PIO_Point := (PIO_0'Access, SM_0);
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;
   Pico.LED.Configure (Output, Pull_Up, PIO0);

   SysTick.Enable;

   PIO_0.Enable;
   SM.Disable;
   SM.Set_Divider (2.5); --  50 MHz clock
   SM.Set_Out_Pins (Base => Pico.LED, Count => 1);
   SM.Set_Set_Pins (Base => Pico.LED, Count => 1);
   SM.Load (Hello.Hello_Program_Instructions, Hello.Hello_Wrap_Target, Hello.Hello_Wrap);
   SM.Restart;
   SM.Execute (16#e081#); --  set pindirs, 1
   SM.Enable;

   loop
      SM.Transmit (1);
      SysTick.Delay_Milliseconds (100);
      SM.Transmit (0);
      SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
