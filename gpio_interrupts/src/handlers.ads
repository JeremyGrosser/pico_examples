--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;

package Handlers is
   procedure Toggle_LED
      (Pin     : GPIO_Pin;
       Trigger : Interrupt_Triggers);
end Handlers;
