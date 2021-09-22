--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Device;
with RP.Clock;
with Pico;

with USB.HAL.Device;
with USB.Device.Serial;
with USB.Device;
with USB;
with HAL; use HAL;

procedure Main is
   Fatal_Error       : exception;
   Max_Packet_Size   : constant := 64;

   USB_Stack         : USB.Device.USB_Device_Stack (Max_Classes => 1);
   USB_Serial        : aliased USB.Device.Serial.Default_Serial_Class
      (TX_Buffer_Size => Max_Packet_Size,
       RX_Buffer_Size => Max_Packet_Size);

   use type USB.Device.Init_Result;
   Status  : USB.Device.Init_Result;

   Hello_Message : constant String := "Hello, Pico!";
   Hello_Count   : Natural := 0;

   Message    : String (1 .. Max_Packet_Size);
   Length     : HAL.UInt32;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);

   if not USB_Stack.Register_Class (USB_Serial'Unchecked_Access) then
      raise Fatal_Error with "Failed to register USB Serial device class";
   end if;

   Status := USB_Stack.Initialize
      (Controller      => RP.Device.UDC'Access,
       Manufacturer    => USB.To_USB_String ("Raspberry Pi"),
       Product         => USB.To_USB_String ("Ada Echo Test"),
       Serial_Number   => USB.To_USB_String ("42"),
       Max_Packet_Size => Max_Packet_Size);

   if Status /= USB.Device.Ok then
      raise Fatal_Error with "USB stack initialization failed: " & Status'Image;
   end if;

   USB_Stack.Start;

   loop
      USB_Stack.Poll;

      if USB_Serial.List_Ctrl_State.DTE_Is_Present then
         USB_Serial.Read (Message, Length);
         if Length > 0 then
            USB_Serial.Write (RP.Device.UDC, Message (1 .. Natural (Length)), Length);
         end if;
      end if;
   end loop;
end Main;
