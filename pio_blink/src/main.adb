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

with System.Storage_Elements; use System.Storage_Elements;
with System;

--  XXX: THIS EXAMPLE DOES NOT WORK YET

procedure Main is
   --  These symbols are absolute values, not pointers, so use the 'Address
   --  attribute as literal. There might be a better way to do this.
   hello_pio_start : Storage_Element
      with Import        => True,
           Alignment     => 4,
           External_Name => "hello_pio_start";
   hello_pio_size  : Storage_Element
      with Import        => True,
           Alignment     => 4,
           External_Name => "hello_pio_size";
   Hello_Size : constant Natural := Natural (To_Integer (hello_pio_size'Address));
   Hello : aliased UInt16_Array (1 .. Hello_Size / 2)
      with Import  => True,
           Address => hello_pio_start'Address;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);

   --  PIO_0.Load (Hello'Access);

   SysTick.Enable;
   loop
      --  PIO_0.Put (1);
      SysTick.Delay_Milliseconds (100);
      --  PIO_0.Put (0);
      SysTick.Delay_Milliseconds (100);
   end loop;
end Main;
