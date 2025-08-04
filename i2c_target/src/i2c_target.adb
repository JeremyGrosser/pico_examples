with HAL;
with RP.GPIO; use RP.GPIO;
with RP.Device;
with RP.Clock;
with RP.I2C;
with Pico;

procedure I2C_Target is
   XOSC_Frequency : constant := 12_000_000;
   SDA  : GPIO_Point renames Pico.GP0;
   SCL  : GPIO_Point renames Pico.GP1;
   Port : RP.I2C.I2C_Port renames RP.Device.I2C_0;
   Addr : constant HAL.UInt7 := 2#1110110#;

   subtype Sensor_Id is HAL.UInt8 range 1 .. 4;
   Data    : constant array (Sensor_Id) of HAL.UInt8 := (others => 42);
   Request : HAL.UInt8;

   use type RP.I2C.I2C_Status;
   Status  : RP.I2C.I2C_Status;
begin
   RP.Clock.Initialize (XOSC_Frequency);
   SDA.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
   SCL.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);

   Port.Configure ((Role => RP.I2C.Target, others => <>));
   Port.Set_Address (Addr);
   Port.Enable;

   loop
      Port.Start_Read (Length => 1);
      if Port.Read_Ready then
         Port.Read (Request, Status);
         if Status = RP.I2C.Ok and then Request in Sensor_Id'Range then
            Port.Start_Write (Length => 1);
            Port.Write (Data (Request), Status);
         end if;
      end if;
   end loop;
end I2C_Target;
