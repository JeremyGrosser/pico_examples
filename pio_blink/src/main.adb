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
   SM_0 : PIO_Point :=
      (Periph => PIO_0'Access,
       SM     => 0);
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;
   Pico.LED.Configure (Output, Pull_Up, PIO0);

   SysTick.Enable;

   RP.PIO.Initialize;
   SM_0.Disable;
   SM_0.Set_Divider (2.5); --  50 MHz clock
   SM_0.Set_Out_Pins (Base => Pico.LED, Count => 1);
   SM_0.Set_Set_Pins (Base => Pico.LED, Count => 1);
   SM_0.Load (Hello.Hello_Program_Instructions, Hello.Hello_Wrap_Target, Hello.Hello_Wrap);
   SM_0.Restart;
   SM_0.Execute (16#e081#); --  set pindirs, 1
   SM_0.Enable;

   loop
      SM_0.Transmit (1);
      SysTick.Delay_Milliseconds (100);
      SM_0.Transmit (0);
      SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
