--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with Ada.Text_IO;

with HAL.SPI; use HAL.SPI;
with HAL;     use HAL;

with RP.DMA;

with Board; use Board;

package body Tests is

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

   procedure Test_Slave_8
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
      A : SPI_Data_8b (1 .. 1) := (others => 0);
      B : SPI_Data_8b (1 .. 1) := (others => 0);
      Status : SPI_Status;
   begin
      Ada.Text_IO.Put (Name & "...");
      SPI_Master.Configure (Master_Config);
      SPI_Slave.Configure (Slave_Config);

      --  Slave to master
      for I in 16#5A# .. 16#6A# loop
         A (1) := UInt8 (I);
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
   end Test_Slave_8;

   procedure Test_DMA
      (Name          : String;
       Master_Config : SPI_Configuration;
       Slave_Config  : SPI_Configuration)
   is
      DMA_Config : constant RP.DMA.DMA_Configuration :=
         (Increment_Read => True,
          Trigger        => RP.DMA.SPI0_TX,
          Data_Size      => RP.DMA.Transfer_16,
          others         => <>);
      TX_Channel : constant RP.DMA.DMA_Channel_Id := RP.DMA.DMA_Channel_Id'First;
      A : SPI_Data_16b (1 .. 8) := (1, 2, 3, 4, 5, 6, 7, 8);
      B : SPI_Data_16b (1 .. 8);
      Status : SPI_Status;
   begin
      Ada.Text_IO.Put (Name & "...");
      SPI_Master.Configure (Master_Config);
      SPI_Slave.Configure (Slave_Config);
      RP.DMA.Enable;

      RP.DMA.Configure (TX_Channel, DMA_Config);
      RP.DMA.Start
         (Channel => TX_Channel,
          From    => A'Address,
          To      => SPI_Master.FIFO_Address,
          Count   => A'Length);

      SPI_Slave.Receive (B, Status);
      pragma Assert (Status = Ok, "Slave receive: " & Status'Image);
      pragma Assert (A = B, "Data mismatch: " & Status'Image);

      RP.DMA.Disable (TX_Channel);

      Ada.Text_IO.Put_Line ("PASS");
   end Test_DMA;

end Tests;
