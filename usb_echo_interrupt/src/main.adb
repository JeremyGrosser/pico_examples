--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Device;
with RP.Clock;
with Pico;

with USB.Device.Serial;
with USB.Device;
with USB;
with HAL; use HAL;

with USB_Int;

procedure Main is
   Message    : String (1 .. USB_Int.Max_Packet_Size);
   Length     : HAL.UInt32;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);

   --  See usb_int.adb for initialization and interrupt handling setup
   USB_Int.Initialize;

   loop
      if USB_Int.USB_Serial.List_Ctrl_State.DTE_Is_Present then
         USB_Int.USB_Serial.Read (Message, Length);
         if Length > 0 then
            USB_Int.USB_Serial.Write (RP.Device.UDC, Message (1 .. Natural (Length)), Length);
         end if;
      end if;
   end loop;
end Main;
