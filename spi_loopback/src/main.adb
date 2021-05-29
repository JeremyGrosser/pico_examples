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

with Ada.Text_IO;

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

   procedure Test_8
      (Name          : String;
       Master_Config : SPI_Configuration;
       Slave_Config  : SPI_Configuration)
   is
      Data_In     : SPI_Data_8b (1 .. 1) := (others => 0);
      Data_Out    : SPI_Data_8b (1 .. 1) := (others => 0);
      Status_In   : SPI_Status;
      Status_Out  : SPI_Status;
   begin
      Ada.Text_IO.Put (Name & "...");
      SPI_Master.Configure (Master_Config);
      SPI_Slave.Configure (Slave_Config);

      --  Master to slave
      for I in 1 .. 10 loop
         Data_Out (1) := UInt8 (I);
         SPI_Master.Transmit (Data_Out, Status_Out);
         pragma Assert (Status_Out = Ok, "Transmit error");
         SPI_Slave.Receive (Data_In, Status_In);
         pragma Assert (Status_In = Ok, "Receive error");
         pragma Assert (Data_Out = Data_In, "Data mismatch");
      end loop;
      Ada.Text_IO.Put_Line ("PASS");
   end Test_8;

   procedure Test_16
      (Name            : String;
       Master_Config   : SPI_Configuration;
       Slave_Config    : SPI_Configuration;
       Transfer_Length : Positive := 1)
   is
      Data_In     : SPI_Data_16b (1 .. Transfer_Length) := (others => 0);
      Data_Out    : SPI_Data_16b (1 .. Transfer_Length) := (others => 0);
      Status_In   : SPI_Status;
      Status_Out  : SPI_Status;
   begin
      Ada.Text_IO.Put (Name & "...");
      SPI_Master.Configure (Master_Config);
      SPI_Slave.Configure (Slave_Config);

      for I in 1 .. 10 loop
         for J in Data_Out'Range loop
            Data_Out (J) := UInt16 (I) + 1;
         end loop;
         SPI_Master.Transmit (Data_Out, Status_Out);
         pragma Assert (Status_Out = Ok, "Transmit error: " & Status_Out'Image);
         SPI_Slave.Receive (Data_In, Status_In);
         pragma Assert (Status_In = Ok, "Receive error: " & Status_In'Image);
         pragma Assert (Data_Out = Data_In, "Data mismatch");
      end loop;

      Ada.Text_IO.Put_Line ("PASS");
   end Test_16;

   procedure Test_Slave
      (Name          : String;
       Master_Config : SPI_Configuration;
       Slave_Config  : SPI_Configuration)
   is
      --  Things need to happen in the following order:
      --    1. Set A := I, B := not I
      --    2. Put A in the slave's transmit FIFO
      --    3. Transmit B from the master to generate a clock
      --    4. Read A from the master FIFO into B, check A = B
      --    5. Read B from the slave FIFO into A, check A = not B
      A : SPI_Data_16b (1 .. 1) := (others => 0);
      B : SPI_Data_16b (1 .. 1) := (others => 0);
      Status : SPI_Status;
   begin
      Ada.Text_IO.Put (Name & "...");
      SPI_Master.Configure (Master_Config);
      SPI_Slave.Configure (Slave_Config);

      --  Slave to master
      for I in 16#5A5A# .. 16#5A6A# loop
         A (1) := UInt16 (I);
         B (1) := not A (1);

         SPI_Slave.Transmit (A, Status);
         pragma Assert (Status = Ok, "Slave transmit: " & Status'Image);

         SPI_Master.Transmit (B, Status);
         pragma Assert (Status = Ok, "Master transmit: " & Status'Image);

         SPI_Master.Receive (B, Status);
         pragma Assert (Status = Ok, "Master receive: " & Status'Image);
         pragma Assert (A = B, "Master received incorrect value: " &
            "A = " & A (1)'Image & ", " &
            "B = " & B (1)'Image);

         SPI_Slave.Receive (A, Status);
         pragma Assert (Status = Ok, "Slave receive: " & Status'Image);
         pragma Assert (A (1) = not B (1));
      end loop;
      Ada.Text_IO.Put_Line ("PASS");
   end Test_Slave;

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

   Test_8 ("Basic loopback",
      Master_Config =>
        (Role   => Master,
         Baud   => 10_000_000,
         others => <>),
      Slave_Config =>
        (Role   => Slave,
         Baud   => 10_000_000,
         others => <>));

   Test_8 ("CPOL=1 CPHA=1",
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
   Test_8 ("25 MHz",
      Master_Config =>
        (Role   => Master,
         Baud   => 25_000_000,
         others => <>),
      Slave_Config =>
        (Role   => Slave,
         Baud   => 25_000_000,
         others => <>));

   Test_16 ("16-bit transfers",
      Master_Config =>
        (Role      => Master,
         Baud      => 25_000_000,
         Data_Size => Data_Size_16b,
         others    => <>),
      Slave_Config =>
        (Role      => Slave,
         Baud      => 25_000_000,
         Data_Size => Data_Size_16b,
         others    => <>));

   Test_16 ("Long transfers",
      Master_Config =>
        (Role      => Master,
         Baud      => 25_000_000,
         Data_Size => Data_Size_16b,
         others    => <>),
      Slave_Config =>
        (Role      => Slave,
         Baud      => 25_000_000,
         Data_Size => Data_Size_16b,
         others    => <>),
      Transfer_Length => 8);

   Test_Slave ("Slave transmit",
      Master_Config =>
        (Role      => Master,
         Baud      => 10_000_000,
         Data_Size => Data_Size_16b,
         others    => <>),
      Slave_Config =>
        (Role      => Slave,
         Baud      => 10_000_000,
         Data_Size => Data_Size_16b,
         others    => <>));

   Ada.Text_IO.Put_Line ("ALL TESTS PASS");
   loop
      RP.Device.Timer.Delay_Milliseconds (100);
      Pico.LED.Toggle;
   end loop;
end Main;
