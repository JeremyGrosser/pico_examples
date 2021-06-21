with RP.Device;
with RP.USB;
with USB;
with HAL;

package USB_CDC_ACM is

   Device_Descriptor : constant USB.USB_Device_Descriptor :=
      (USB                 => 16#0110#,
       Device_Class        => 0,
       Device_SubClass     => 0,
       Device_Protocol     => 0,
       Max_Packet_Size_0   => 64,
       Id_Vendor           => 16#0000#,
       Id_Product          => 16#0001#,
       Device_Version      => 0,
       Manufacturer_Index  => 1,
       Product_Index       => 2,
       Serial_Number_Index => 0,
       Num_Configurations  => 1,
       others              => <>);

   Interface_Descriptor : constant USB.USB_Interface_Descriptor :=
      (Interface_Number    => 0,
       Alternate_Setting   => 0,
       Num_Endpoints       => 2,
       Interface_Class     => 16#FF#,
       Interface_SubClass  => 0,
       Interface_Protocol  => 0,
       Interface_Index     => 0,
       others              => <>);

   EP0_Out : constant USB.USB_Endpoint_Descriptor :=
      (Endpoint_Address    => (USB.Dir_Out, 0),
       Endpoint_Attributes => (Transfer_Type => USB.Control),
       Max_Packet_Size     => 64,
       Interval            => 0,
       Refresh             => 0,
       Sync_Address        => 0,
       others              => <>);

   EP0_In : constant USB.USB_Endpoint_Descriptor :=
      (Endpoint_Address    => (USB.Dir_In, 0),
       Endpoint_Attributes => (Transfer_Type => USB.Control),
       Max_Packet_Size     => 64,
       Interval            => 0,
       Refresh             => 0,
       Sync_Address        => 0,
       others              => <>);

   EP1_Out : constant USB.USB_Endpoint_Descriptor :=
      (Endpoint_Address    => (USB.Dir_Out, 1),
       Endpoint_Attributes => (Transfer_Type => USB.Bulk),
       Max_Packet_Size     => 64,
       Interval            => 0,
       Refresh             => 0,
       Sync_Address        => 0,
       others              => <>);

   EP2_In : constant USB.USB_Endpoint_Descriptor :=
      (Endpoint_Address    => (USB.Dir_In, 2),
       Endpoint_Attributes => (Transfer_Type => USB.Bulk),
       Max_Packet_Size     => 64,
       Interval            => 0,
       Refresh             => 0,
       Sync_Address        => 0,
       others              => <>);

   use type HAL.UInt16;
   Config_Descriptor : constant USB.USB_Configuration_Descriptor :=
      (Total_Length              =>
         (USB.USB_Configuration_Descriptor'Size +
          USB.USB_Interface_Descriptor'Size +
          USB.USB_Endpoint_Descriptor'Size +
          USB.USB_Endpoint_Descriptor'Size) / 8,
       Num_Interfaces            => 1,
       Configuration_Value       => 1,
       Configuration_Index       => 0,
       Configuration_Attributes  => 16#C0#, --  self powered, no remote wakeup
       Max_Power                 => 16#32#, --  100mA
       others                    => <>);

   Lang_Descriptor : aliased HAL.UInt8_Array :=
      (4, 16#03#, 16#09#, 16#04#); --  us english

   Descriptor_Strings : aliased RP.USB.USB_Descriptor_Strings :=
      ("Raspberry Pi", "Pico Test Device");

   procedure EP0_Out_Handler;
   procedure EP0_In_Handler;
   procedure EP1_Out_Handler;
   procedure EP2_In_Handler;

   Device_Configuration : constant RP.USB.USB_Device_Configuration :=
      (Device_Descriptor        => Device_Descriptor,
       Interface_Descriptor     => Interface_Descriptor,
       Configuration_Descriptor => Config_Descriptor,
       Language_Descriptor      => Lang_Descriptor'Access,
       Descriptor_Strings       => Descriptor_Strings'Access,
       Endpoints                =>
         (
            (Descriptor       => EP0_Out,
             Handler          => EP0_Out_Handler'Access,
             Endpoint_Control => null,
             Buffer_Control   => RP.Device.USB_DPRAM_Periph.EP_BUF_CTRL (0).EP_OUT'Access,
             Data_Buffer      => RP.Device.USB_DPRAM_Periph.EP_BUF_A (0)'Access),

            (Descriptor       => EP0_In,
             Handler          => EP0_In_Handler'Access,
             Endpoint_Control => null,
             Buffer_Control   => RP.Device.USB_DPRAM_Periph.EP_BUF_CTRL (0).EP_IN'Access,
             Data_Buffer      => RP.Device.USB_DPRAM_Periph.EP_BUF_A (0)'Access),

            (Descriptor       => EP1_Out,
             Handler          => EP1_Out_Handler'Access,
             Endpoint_Control => RP.Device.USB_DPRAM_Periph.EP_CTRL (0).EP_OUT'Access,
             Buffer_Control   => RP.Device.USB_DPRAM_Periph.EP_BUF_CTRL (1).EP_OUT'Access,
             Data_Buffer      => RP.Device.USB_DPRAM_Periph.EPX_DATA (0 * 64)'Access),

            (Descriptor       => EP2_In,
             Handler          => EP2_In_Handler'Access,
             Endpoint_Control => RP.Device.USB_DPRAM_Periph.EP_CTRL (1).EP_IN'Access,
             Buffer_Control   => RP.Device.USB_DPRAM_Periph.EP_BUF_CTRL (2).EP_IN'Access,
             Data_Buffer      => RP.Device.USB_DPRAM_Periph.EPX_DATA (1 * 64)'Access)
          )
      );


end USB_CDC_ACM;
