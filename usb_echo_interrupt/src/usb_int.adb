--
--  Copyright 2022 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with RP_Interrupts;
with Cortex_M.NVIC;

with RP2040_SVD.Interrupts;

with RP.Device;

with USB.Device;
with USB;

package body USB_Int is

   Fatal_Error : exception;

   Int_ID : constant RP_Interrupts.Interrupt_ID :=
     RP2040_SVD.Interrupts.USBCTRL_Interrupt;

   USB_Stack : USB.Device.USB_Device_Stack (Max_Classes => 1);

   procedure USB_Int_Handler is
   begin

      --  Interrupt based USB device only requiers to call the stack Poll
      --  procedure for every interrupt of the RP USB device controller.
      USB_Stack.Poll;

   end USB_Int_Handler;

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

      --  Attach a handler to the RP USB device controller interrupt
      RP_Interrupts.Attach_Handler
        (USB_Int_Handler'Access,
         Int_ID,
         RP_Interrupts.Interrupt_Priority'First);

      --  Enable the RP USB device controller interrupt
      Cortex_M.NVIC.Enable_Interrupt (Int_ID);

   end Initialize;

end USB_Int;
