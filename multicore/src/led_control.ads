--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  The runtime starts both CPU cores. Tasks run on the first core unless
--  they're assigned to the second one with the CPU aspect.
--
package LED_Control is

   procedure Initialize;
   --  Initialize configures the GPIO

   procedure Run;
   --  Run signals the Blinker task once every second from the environment
   --  task, which runs on the first core. Does not return.

private

   task Blinker
      with CPU => 2;
   --  Blinker runs on the second core. It waits for a signal, then toggles
   --  the LED.

end LED_Control;
