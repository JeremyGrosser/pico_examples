--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Device; use RP.Device;
with RP.GPIO;   use RP.GPIO;
with RP.Clock;
with RP.PIO;
with Pico;
with Hello;

procedure Main is
   Config : RP.PIO.PIO_SM_Config := RP.PIO.Default_SM_Config;
   SM     : constant RP.PIO.PIO_SM := 0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output, Pull_Up, PIO0);

   RP.PIO.Set_Out_Pins (Config, Pico.LED.Pin, 1);
   RP.PIO.Set_Set_Pins (Config, Pico.LED.Pin, 1);
   RP.PIO.Set_Wrap (Config,
      Wrap_Target => Hello.Hello_Wrap_Target,
      Wrap        => Hello.Hello_Wrap);
   RP.PIO.Set_Clock_Frequency (Config, 50_000_000);

   RP.PIO.Enable (PIO_0);
   RP.PIO.Load (PIO_0, Hello.Hello_Program_Instructions, 0);
   RP.PIO.SM_Initialize (PIO_0, SM, 0, Config);
   RP.PIO.Set_Pin_Direction (PIO_0, SM, Pico.LED.Pin, RP.PIO.Output);

   SysTick.Enable;
   loop
      RP.PIO.Put (PIO_0, SM, 1);
      SysTick.Delay_Milliseconds (100);
      RP.PIO.Put (PIO_0, SM, 0);
      SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
