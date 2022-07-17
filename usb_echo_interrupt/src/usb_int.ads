--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with USB.Device.Serial;

package USB_Int is

   Max_Packet_Size : constant := 64;
   USB_Serial      : aliased USB.Device.Serial.Default_Serial_Class
     (TX_Buffer_Size => Max_Packet_Size,
      RX_Buffer_Size => Max_Packet_Size);

   procedure Initialize;

end USB_Int;
