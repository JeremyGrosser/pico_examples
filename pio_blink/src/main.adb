--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with RP.PIO;  use RP.PIO;
with RP.Device;
with RP.Clock;
with Pico;
with Hello;

procedure Main is
   Program_Offset : constant PIO_Address := 0;
   SM             : constant PIO_SM := 0;
   Config         : PIO_SM_Config := Default_SM_Config;
   P              : PIO_Device renames RP.Device.PIO_0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output, Pull_Up, P.GPIO_Function);

   P.Enable;
   P.Load (Hello.Hello_Program_Instructions, Program_Offset);

   Set_Out_Pins (Config, Pico.LED.Pin, 1);
   Set_Set_Pins (Config, Pico.LED.Pin, 1);
   Set_Wrap (Config,
      Wrap_Target => Hello.Hello_Wrap_Target,
      Wrap        => Hello.Hello_Wrap);
   Set_Clock_Frequency (Config, 50_000_000);

   P.SM_Initialize (SM,
      Initial_PC => Program_Offset,
      Config     => Config);
   P.Set_Pin_Direction (SM, Pico.LED.Pin, Output);
   P.Set_Enabled (SM, True);

   RP.Device.Timer.Enable;
   loop
      P.Put (SM, 1);
      RP.Device.Timer.Delay_Milliseconds (100);
      P.Put (SM, 0);
      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end Main;
