--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.SPI; use HAL.SPI;
with HAL;     use HAL;
with RP.SPI;  use RP.SPI;
with RP.GPIO; use RP.GPIO;
with RP.Device;
with RP.Clock;
with Pico;

with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   SPI_Master : RP.SPI.SPI_Port renames RP.Device.SPI_0;
   SPI_Slave  : RP.SPI.SPI_Port renames RP.Device.SPI_1;

   Master_MISO : GPIO_Point renames Pico.GP0;
   Master_NSS  : GPIO_Point renames Pico.GP1;
   Master_SCK  : GPIO_Point renames Pico.GP2;
   Master_MOSI : GPIO_Point renames Pico.GP3;

   Slave_MISO  : GPIO_Point renames Pico.GP11;
   Slave_NSS   : GPIO_Point renames Pico.GP9;
   Slave_SCK   : GPIO_Point renames Pico.GP10;
   Slave_MOSI  : GPIO_Point renames Pico.GP12;

   Baud        : constant := 10_000_000;
   Data_In     : SPI_Data_8b (1 .. 1) := (others => 0);
   Data_Out    : SPI_Data_8b (1 .. 1) := (others => 0);
   Status_In   : SPI_Status;
   Status_Out  : SPI_Status;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Device.Timer.Enable;
   Pico.LED.Configure (Output);

   Master_MISO.Configure (Input, Pull_Up, RP.GPIO.SPI);
   Master_NSS.Configure (Output, Pull_Up, RP.GPIO.SPI);
   Master_SCK.Configure (Output, Pull_Up, RP.GPIO.SPI);
   Master_MOSI.Configure (Output, Pull_Up, RP.GPIO.SPI);

   Slave_MISO.Configure (Output, Floating, RP.GPIO.SPI);
   Slave_NSS.Configure (Input, Floating, RP.GPIO.SPI);
   Slave_SCK.Configure (Input, Floating, RP.GPIO.SPI);
   Slave_MOSI.Configure (Input, Floating, RP.GPIO.SPI);

   SPI_Master.Configure (
      (Role   => Master,
       Baud   => 10_000_000,
       others => <>));

   SPI_Slave.Configure (
      (Role   => Slave,
       Baud   => 10_000_000,
       others => <>));

   loop
      Data_Out (1) := Data_Out (1) + 1;
      SPI_Master.Transmit (Data_Out, Status_Out);
      SPI_Slave.Receive (Data_In, Status_In);
      if Data_In /= Data_Out then
         Put_Line ("Receive buffer does not match transmit buffer!");
      else
         Put_Line (Data_In (1)'Image);
      end if;
      RP.Device.Timer.Delay_Milliseconds (100);
      Pico.LED.Toggle;
   end loop;
end Main;
