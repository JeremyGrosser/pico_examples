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
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;

   Pico.LED.Configure (Output, Pull_Up, PIO0);

   RP.PIO.Initialize;
   PIO_0.Configure (0,
      (Clock_Divider  => RP.PIO.To_Divider (Frequency => 50_000_000),
       Out_Base       => Pico.LED,
       Out_Count      => 1,
       Set_Base       => Pico.LED,
       Set_Count      => 1,
       others         => <>));
   PIO_0.Load (0,
      Prog        => Hello.Hello_Program_Instructions,
      Wrap_Target => Hello.Hello_Wrap_Target,
      Wrap        => Hello.Hello_Wrap);
   PIO_0.Execute (0, 16#e081#); --  set pindirs, 1
   PIO_0.Enable ((0 => True, others => False));

   SysTick.Enable;
   loop
      PIO_0.Transmit (0, 1);
      SysTick.Delay_Milliseconds (100);
      PIO_0.Transmit (0, 0);
      SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
