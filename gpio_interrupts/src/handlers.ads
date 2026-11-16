--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Interrupts.Names;
with System;
with RP.GPIO;
with Pico;

package Handlers is

   Button : RP.GPIO.GPIO_Point renames Pico.GP9;

   --  All GPIO pins share one interrupt per CPU core. The runtime attaches
   --  the handler and enables the interrupt during elaboration.
   protected GPIO
      with Interrupt_Priority => System.Interrupt_Priority'Last
   is
      procedure Handler
         with Attach_Handler =>
            Ada.Interrupts.Names.IO_IRQ_BANK0_Interrupt_CPU_1;
   end GPIO;

end Handlers;
