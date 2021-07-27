--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Pico;

package body Handlers is
   procedure Toggle_LED
      (Pin     : GPIO_Pin;
       Trigger : Interrupt_Triggers)
   is
      pragma Unreferenced (Pin);
      pragma Unreferenced (Trigger);
   begin
      Pico.LED.Toggle;
   end Toggle_LED;
end Handlers;
