--
--  Copyright 2021-2026 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Handlers is
   protected body GPIO is
      procedure Handler is
         use RP.GPIO.Interrupt;
      begin
         if Triggered (Button.Pin, Falling) then
            --  Edge triggered interrupts stay pending until acknowledged
            Acknowledge (Button.Pin, Falling);
            Pico.LED.Toggle;
         end if;
      end Handler;
   end GPIO;
end Handlers;
