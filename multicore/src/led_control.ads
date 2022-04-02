--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package LED_Control is

   procedure Initialize;
   --  Initialize configures the clock and GPIO

   procedure Start;
   --  Start wakes up Core 1 and configures it to call Run_Core1

private

   procedure Run_Core0;
   --  Run_Core0 pushes into the multicore FIFO once every second

   procedure Run_Core1;
   --  Run_Core1 blocks on reading from the FIFO, then toggles the LED

end LED_Control;
