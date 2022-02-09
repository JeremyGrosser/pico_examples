--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.PIO.Encoding; use RP.PIO.Encoding;
with RP.PIO; use RP.PIO;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

procedure Main is
   Blink_Program : constant RP.PIO.Program :=
      (Encode (PULL'       (Block => True, others => <>)),
       Encode (SHIFT_OUT'  (Destination => PINS, Bit_Count => 1, others => <>)));
   Program_Offset : constant PIO_Address := 0;
   SM             : constant PIO_SM := 0;
   Config         : PIO_SM_Config := Default_SM_Config;
   P              : PIO_Device renames RP.Device.PIO_0;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   Pico.LED.Configure (RP.GPIO.Output, RP.GPIO.Floating, P.GPIO_Function);

   P.Enable;
   P.Load (Blink_Program, Program_Offset);

   Set_Out_Pins (Config, Pico.LED.Pin, 1);
   Set_Set_Pins (Config, Pico.LED.Pin, 1);
   Set_Wrap (Config,
      Wrap_Target => 0,
      Wrap        => Blink_Program'Length);
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
