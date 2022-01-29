--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Feather_RP2040;
with RP.Device;
with RP.Clock;
with RP.GPIO;

procedure Main is
   package Board renames Feather_RP2040;
begin
   RP.Clock.Initialize (Board.XOSC_Frequency, Board.XOSC_Startup_Delay);
   Board.LED.Configure (RP.GPIO.Output);
   RP.Device.Timer.Enable;
   loop
      Board.LED.Toggle;
      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end Main;
