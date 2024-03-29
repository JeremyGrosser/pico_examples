--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Clock;
with RP.GPIO;
with Pico;

with Console;

procedure Main is
   Ch : Character;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   Pico.GP16.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.UART); -- UART0 TX
   Pico.GP17.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.UART); -- UART0 RX

   Console.Configure;

   loop
      Console.Get (Ch);
      Console.Put (Ch);
   end loop;
end Main;
