--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Feather_RP2040; use Feather_RP2040;
with RP.Device;
with RP.Clock;
with RP.GPIO;

procedure Main is
begin
   RP.Clock.Initialize (XOSC_Frequency, XOSC_Startup_Delay);
   LED.Configure (RP.GPIO.Output);
   RP.Device.Timer.Enable;
   loop
      LED.Toggle;
      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end Main;
