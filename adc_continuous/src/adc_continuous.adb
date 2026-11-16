--
--  Copyright 2021-2026 (C) Jeremy Grosser
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
with Sample_Buffers; use Sample_Buffers;
with Pico;

procedure Adc_continuous is
   DMA_Channel  : constant DMA_Channel_Id := 0;

   Channels     : constant ADC_Channels := (0 .. 1 => True, others => False);

   --  See sample_buffers.ads for the buffer definitions
   Writing : Buffer_Index := A;
   Reading : Buffer_Index := B;
begin
   Pico.SMPS_PS.Configure (Output, Pull_Up);
   Pico.SMPS_PS.Set;

   RP.ADC.Enable;
   Configure (Channels);
   Set_Round_Robin (Channels);
   Set_Sample_Rate (Sample_Rate * Num_Channels);
   Set_Sample_Bits (12);

   RP.DMA.Enable;
   RP.DMA.Configure (DMA_Channel,
      (Write_Address => Increment,
       Data_Size     => Transfer_16,
       Trigger       => RP.DMA.ADC,
       others        => <>));

   --  Start the first DMA transfer
   RP.DMA.Start
      (Channel => DMA_Channel,
       From  => RP.ADC.FIFO_Address,
       To    => Buffers (Writing)'Address,
       Count => Buffers (Writing)'Length);

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
          Count => Buffers (Writing)'Length);

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
