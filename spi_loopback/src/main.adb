--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Text_IO;

with HAL.SPI;

with RP.SPI; use RP.SPI;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;

with Board;
with Tests;

procedure Main is
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Device.Timer.Enable;
   Pico.LED.Configure (RP.GPIO.Output);

   Board.Initialize;

   Tests.Test_8 ("Basic loopback",
      Master_Config =>
        (Role   => Master,
         Baud   => 10_000_000,
         others => <>),
      Slave_Config =>
        (Role   => Slave,
         Baud   => 10_000_000,
         others => <>));

   Tests.Test_8 ("CPOL=1 CPHA=1",
      Master_Config =>
        (Role     => Master,
         Baud     => 10_000_000,
         Polarity => Active_High,
         Phase    => Falling_Edge,
         others   => <>),
      Slave_Config =>
        (Role     => Slave,
         Baud     => 10_000_000,
         Polarity => Active_High,
         Phase    => Falling_Edge,
         others   => <>));

   --  If this fails, it's probably due to poor wiring.
   Tests.Test_8 ("25 MHz",
      Master_Config =>
        (Role   => Master,
         Baud   => 25_000_000,
         others => <>),
      Slave_Config =>
        (Role   => Slave,
         Baud   => 25_000_000,
         others => <>));

   Tests.Test_16 ("16-bit transfers",
      Master_Config =>
        (Role      => Master,
         Baud      => 25_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>),
      Slave_Config =>
        (Role      => Slave,
         Baud      => 25_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>));

   Tests.Test_16 ("Long transfers",
      Master_Config =>
        (Role      => Master,
         Baud      => 25_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>),
      Slave_Config =>
        (Role      => Slave,
         Baud      => 25_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>),
      Transfer_Length => 8);

   Tests.Test_Slave ("Slave transmit",
      Master_Config =>
        (Role      => Master,
         Baud      => 10_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>),
      Slave_Config =>
        (Role      => Slave,
         Baud      => 10_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>));

   Tests.Test_DMA ("DMA transmit",
      Master_Config =>
        (Role      => Master,
         Baud      => 10_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>),
      Slave_Config =>
        (Role      => Slave,
         Baud      => 10_000_000,
         Data_Size => HAL.SPI.Data_Size_16b,
         others    => <>));

   Ada.Text_IO.Put_Line ("ALL TESTS PASS");
   loop
      RP.Device.Timer.Delay_Milliseconds (100);
      Pico.LED.Toggle;
   end loop;
end Main;
