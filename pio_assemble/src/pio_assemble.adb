--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.PIO.Encoding; use RP.PIO.Encoding;
with RP.PIO; use RP.PIO;
with RP.GPIO;
with Pico;

procedure Pio_assemble is
   Blink_Program : constant RP.PIO.Program :=
      (Encode (PULL'(Block => True, others => <>)),
       Encode (SHIFT_OUT'(Destination => PINS, Bit_Count => 1, others => <>)));
   Program_Offset : constant PIO_Address := 0;
   SM             : constant SM_Index := 0;
   Config         : SM_Config := Default_SM_Config;
   P              : constant RP.PIO.Device := 0;
begin
   Pico.LED.Configure (RP.GPIO.Output, RP.GPIO.Floating, GPIO_Function (P));

   Enable (P);
   Load (P, Blink_Program, Program_Offset);

   Set_Out_Pins (Config, Pico.LED.Pin, 1);
   Set_Set_Pins (Config, Pico.LED.Pin, 1);
   Set_Wrap (Config,
      Wrap_Target => Program_Offset,
      Wrap        => Program_Offset + Blink_Program'Length);
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
end Pio_assemble;
