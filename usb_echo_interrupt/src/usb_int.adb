--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with Ada.Interrupts.Names;
with RP.Device;

with USB.Device;
with USB;

package body USB_Int is

   Fatal_Error : exception;

   USB_Stack : USB.Device.USB_Device_Stack (Max_Classes => 1);

   protected Interrupts is
      procedure USB_Int_Handler
         with Attach_Handler => Ada.Interrupts.Names.USBCTRL_Interrupt_CPU_1;
   end Interrupts;

   protected body Interrupts is
      procedure USB_Int_Handler is
      begin
         USB_Stack.Poll;
      end USB_Int_Handler;
   end Interrupts;

   procedure Poll is
   begin
      USB_Stack.Poll;
   end Poll;

   procedure Initialize is
      use type USB.Device.Init_Result;
      Status : USB.Device.Init_Result;
   begin
      if not USB_Stack.Register_Class (USB_Serial'Unchecked_Access) then
         raise Fatal_Error with "Failed to register USB Serial device class";
      end if;

      Status := USB_Stack.Initialize
        (Controller      => RP.Device.UDC'Access,
         Manufacturer    => USB.To_USB_String ("Raspberry Pi"),
         Product         => USB.To_USB_String ("Ada Echo Int Test"),
         Serial_Number   => USB.To_USB_String ("42"),
         Max_Packet_Size => Max_Packet_Size);

      if Status /= USB.Device.Ok then
         raise Fatal_Error with "USB stack initialization failed: " & Status'Image;
      end if;

      USB_Stack.Start;
   end Initialize;

end USB_Int;
