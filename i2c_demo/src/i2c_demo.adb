with RP.GPIO; use RP.GPIO;
with RP.Clock;
with RP.Device;
with RP.Timer;

with RP2040_SVD.I2C;
with RP.I2C;
with RP.I2C_Master;
with HAL; use HAL;
with HAL.I2C; use HAL.I2C;

with Ada.Text_IO; use Ada.Text_IO;

--
--  There are two I2C drivers in rp2040_hal; RP.I2C and RP.I2C_Master. RP.I2C
--  implements low level functionality and interfaces with the hardware
--  controller directly, whereas RP.I2C_Master provides a high level
--  implementation of the HAL.I2C interface.
--
--  RP.I2C supports both Controller (Master) and Target (Slave) roles and has
--  more detailed error reporting.
--
--  RP.I2C_Master is generally simpler to work with, but may not work with some
--  older devices.
--
--  This demo provides examples for both interfaces.
--
procedure I2C_Demo is
   SDA    : GPIO_Point := (Pin => 0);
   SCL    : GPIO_Point := (Pin => 1);

   -- The HAL.I2C address is shifted to the left compared to the RP.I2C address.
   -- This is because the HAL.I2C driver itself shifts the provided address to the right.
   -- Due to this behavior the address must be declared as 8 bit.
   Addr     : constant UInt7 := 2#1110110#;
   Addr_HAL : constant UInt8 := 2#11101100#;

   REG_CHIP_ID : constant UInt8 := 16#D0#;

   --  Read the chip ID register from a BME280/BMP280 sensor using the low level RP.I2C interface
   procedure Read_Id is
      use type RP.Timer.Time;
      use type RP.I2C.I2C_Status;
      Port     : aliased RP.I2C.I2C_Port (0, RP2040_SVD.I2C.I2C0_Periph'Access);
      Timing   : constant RP.I2C.I2C_Timing := (RP.I2C.Standard_Mode with delta Rise => 452, Fall => 10);
      Deadline : constant RP.Timer.Time := RP.Timer.Clock + RP.Timer.Milliseconds (100);
      Status   : RP.I2C.I2C_Status;
      Chip_Id  : UInt8;
   begin
      Port.Configure ((Role => RP.I2C.Controller, Timing => Timing));
      Port.Disable (Deadline);
      if Port.Enabled then
         Put_Line ("Disable failed, is SCL stuck low?");
         return;
      end if;
      Port.Set_Address (Addr);
      Port.Enable (Deadline);
      if not Port.Enabled then
         Put_Line ("Enable failed, is SCL stuck low?");
         return;
      end if;

      Port.Start_Write (1, Stop => False, Deadline => Deadline);
      Port.Write (REG_CHIP_ID, Status, Deadline => Deadline);
      if Status /= RP.I2C.Ok then
         Put_Line ("Write register address error");
         return;
      end if;

      Port.Start_Read (1);
      Port.Read (Chip_Id, Status, Deadline => Deadline);
      if Status /= RP.I2C.Ok then
         Put_Line ("Read chip id error");
         return;
      end if;
      Put ("RP.I2C:");
      Put (Chip_Id'Image);
      New_Line;

      Port.Disable (Deadline);
   end Read_Id;

   --  Now with the high level HAL.I2C interface
   procedure Read_Id_HAL is
      use type HAL.I2C.I2C_Status;
      Port   : aliased RP.I2C_Master.I2C_Master_Port (0, RP2040_SVD.I2C.I2C0_Periph'Access);
      Data   : I2C_Data (1 .. 1);
      Status : HAL.I2C.I2C_Status;
   begin
      Port.Configure
         (Baudrate     => 100_000,
          Address_Size => RP.I2C_Master.Address_Size_7b);
      Port.Mem_Read
         (Addr          => I2C_Address (Addr_HAL),
          Mem_Addr      => UInt16 (REG_CHIP_ID),
          Mem_Addr_Size => Memory_Size_8b,
          Data          => Data,
          Status        => Status,
          Timeout       => 1000);
      if Status /= HAL.I2C.Ok then
         Put_Line ("Read chip id error (HAL)");
         return;
      end if;
      Put ("RP.I2C_Master:");
      Put (Data (1)'Image);
      New_Line;
   end Read_Id_HAL;
begin
   RP.Clock.Initialize (12_000_000);
   SDA.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
   SCL.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);

   RP.Device.Timer.Enable;
   loop
      Read_Id;
      Read_Id_HAL;
      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end I2C_Demo;
