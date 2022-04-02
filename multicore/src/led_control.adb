--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with System.Storage_Elements; use System.Storage_Elements;
with RP2040_SVD.PPB;
with RP.Multicore.FIFO;
with RP.Multicore;
with RP.Timer;
with RP.Clock;
with RP.GPIO;
with Pico;
with HAL;

package body LED_Control is

   procedure Initialize is
   begin
      RP.Clock.Initialize (Pico.XOSC_Frequency);
      Pico.LED.Configure (RP.GPIO.Output);
   end Initialize;

   procedure Start is
      --  By default, both cores have a 4 KB stack in the non-striped address space
      --  Core 0's stack is in SCRATCH_Y, SRAM4_BASE 0x20040000
      --  Core 1's stack is in SCRATCH_X, SRAM5_BASE 0x20041000
      --  See the linker script, memmap_default.ld, for more information
      --
      --  Both cores can access the entire address space, so this is just
      --  convention, not a requirement. Put the stack wherever you want.
      VTOR : constant System.Address := To_Address (Integer_Address (RP2040_SVD.PPB.PPB_Periph.VTOR.TBLOFF));
      Stack_One_Top : HAL.UInt32
         with Import, External_Name => "__StackOneTop";
   begin
      RP.Multicore.Launch_Core1
         (Trap_Vector   => VTOR,                  --  Use the same vector table as Core 0
          Stack_Pointer => Stack_One_Top'Address, --  Initial stack pointer (SP)
          Entry_Point   => Run_Core1'Address);    --  Initial program counter (PC)
      Run_Core0;
   end Start;

   procedure Run_Core0 is
      use RP.Timer;
      D : Delays;
      T : Time := Clock;
   begin
      D.Enable;
      loop
         T := T + Milliseconds (1_000);
         D.Delay_Until (T);
         RP.Multicore.FIFO.Push_Blocking (3);
      end loop;
   end Run_Core0;

   procedure Run_Core1 is
      N : Natural with Volatile;
   begin
      loop
         Pico.LED.Toggle;
         N := Natural (RP.Multicore.FIFO.Pop_Blocking);
      end loop;
   end Run_Core1;

end LED_Control;
