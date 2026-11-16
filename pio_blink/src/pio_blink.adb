--
--  Copyright 2021-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with RP.PIO;  use RP.PIO;
with Pico;
with Hello;

procedure Pio_blink is
   Program_Offset : constant PIO_Address := 0;
   SM             : constant SM_Index := 0;
   Config         : SM_Config := Default_SM_Config;
   P              : constant RP.PIO.Device := 0;
begin
   Pico.LED.Configure (Output, Pull_Up, RP.PIO.GPIO_Function (P));

   Enable (P);
   Load (P, Hello.Hello_Program_Instructions, Program_Offset);

   Set_Out_Pins (Config, Pico.LED.Pin, 1);
   Set_Set_Pins (Config, Pico.LED.Pin, 1);
   Set_Wrap (Config,
      Wrap_Target => Hello.Hello_Wrap_Target,
      Wrap        => Hello.Hello_Wrap);
   Set_Clock_Frequency (Config, 50_000_000);

   SM_Initialize (P, SM,
      Initial_PC => Program_Offset,
      Config     => Config);
   Set_Pin_Direction (P, SM, Pico.LED.Pin, Output);
   Set_Enabled (P, SM, True);

   loop
      Put (P, SM, 1);
      delay 0.1;
      Put (P, SM, 0);
      delay 0.1;
   end loop;
end Pio_blink;
