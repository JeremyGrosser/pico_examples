--
--  Copyright 2021-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  The sample buffers are declared at library level because they are far
--  larger than the environment task's stack.
--
pragma Style_Checks ("M120");
with HAL; use HAL;
with RP;  use RP;

package Sample_Buffers is
   Sample_Rate  : constant Hertz := 48_000;
   Num_Channels : constant := 2;

   type Sample is new UInt16;
   --  DMA transfers must be a multiple of 8 bits wide, so we allocate 16 bit
   --  buffers to store our 12 bit samples.

   --  Buffer 100 milliseconds at a time.
   type Sample_Buffer is array (1 .. (Sample_Rate / 10) * Num_Channels) of Sample
      with Component_Size => 16;

   --  Double buffer so we can process samples while DMA is filling
   type Buffer_Index is (A, B);
   Buffers : array (Buffer_Index) of Sample_Buffer := (others => (others => 0));
end Sample_Buffers;
