--
--  Copyright 2022-2026 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  The strip holds a buffer of pixel data, so it is declared at library
--  level rather than on the environment task's stack.
--
with RP.PIO.WS2812;
with Pico;

package Lights is
   Strip : aliased RP.PIO.WS2812.Strip
      (Pin => Pico.GP28'Access,
       PIO => 0,
       SM  => 0,
       Number_Of_LEDs => 300);
end Lights;
