--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  This example configures the ADC to read 12-bit samples from channels 0 and
--  1 at 48 KHz. Two buffers are allocated and DMA is used to write one while
--  the other is being read.
--
--  This example produces no output.
--
pragma Style_Checks ("M120");
with RP.GPIO;     use RP.GPIO;
with RP.ADC;      use RP.ADC;
with RP.DMA;      use RP.DMA;
with RP;          use RP;
with HAL;         use HAL;
with RP.Clock;
with Pico;

procedure Adc_continuous is
   DMA_Channel  : constant DMA_Channel_Id := 0;

   Sample_Rate  : constant Hertz := 48_000;
   Num_Channels : constant := 2;
   Channels     : constant ADC_Channels := (0 .. 1 => True, others => False);

   type Sample is new UInt16;
   --  DMA transfers must be a multiple of 8 bits wide, so we allocate 16 bit
   --  buffers to store our 12 bit samples.

   --  Buffer 100 milliseconds at a time.
   type Sample_Buffer is array (1 .. (Sample_Rate / 10) * Num_Channels) of Sample
      with Component_Size => 16;

   --  Double buffer so we can process samples while DMA is filling
   type Buffer_Index is (A, B);
   Buffers : array (Buffer_Index) of Sample_Buffer := (others => (others => 0));
   Writing : Buffer_Index := A;
   Reading : Buffer_Index := B;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);

   Pico.SMPS_PS.Configure (Output, Pull_Up);
   Pico.SMPS_PS.Set;

   RP.ADC.Enable;
   Configure (Channels);
   Set_Round_Robin (Channels);
   Set_Sample_Rate (Sample_Rate * Num_Channels);
   Set_Sample_Bits (12);

   RP.DMA.Enable;
   RP.DMA.Configure (DMA_Channel,
      (Increment_Write => True,
       Data_Size       => Transfer_16,
       Trigger         => RP.DMA.ADC,
       others          => <>));

   --  Start the first DMA transfer
   RP.DMA.Start
      (Channel => DMA_Channel,
       From  => RP.ADC.FIFO_Address,
       To    => Buffers (Writing)'Address,
       Count => UInt32 (Buffers (Writing)'Length));

   --  Begin sampling the ADC
   RP.ADC.Set_Mode (Free_Running);

   loop
      --  Wait for DMA to complete
      while Busy (DMA_Channel) loop
         null;
      end loop;

      --  Swap buffers and start another DMA transfer
      declare
         Tmp : Buffer_Index;
      begin
         Tmp := Reading;
         Reading := Writing;
         Writing := Tmp;
      end;
      RP.DMA.Start
         (Channel => DMA_Channel,
          From  => RP.ADC.FIFO_Address,
          To    => Buffers (Writing)'Address,
          Count => UInt32 (Buffers (Writing)'Length));

      --  Process the completed buffer
      declare
         Frame : array (1 .. Num_Channels) of Sample;
         I     : Integer := Buffers (Reading)'First;
      begin
         while I < Buffers (Reading)'Last loop
            for J in Frame'Range loop
               Frame (J) := Buffers (Reading) (I);
               I := I + 1;
            end loop;

            --  Do something interesting with Frame here.
         end loop;
      end;
   end loop;
end Adc_continuous;
