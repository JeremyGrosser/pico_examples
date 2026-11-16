--
--  Copyright (C) 2022-2026 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.GPIO; use RP.GPIO;
with RP.Device;

with RP.I2C_Master;
with HAL; use HAL;
with HAL.I2C; use HAL.I2C;

with Ada.Text_IO; use Ada.Text_IO;

procedure I2C_Demo is
   SDA    : constant GPIO_Point := (Pin => 0);
   SCL    : constant GPIO_Point := (Pin => 1);

   Addr_HAL : constant HAL.I2C.I2C_Address := 2#11101100#;

   REG_CHIP_ID : constant UInt8 := 16#D0#;

   --  Read the chip ID register from a BME280/BMP280
   procedure Read_Id_HAL is
      Port   : RP.I2C_Master.I2C_Master_Port renames RP.Device.I2CM_0;
      Data   : I2C_Data (1 .. 1);
      Status : HAL.I2C.I2C_Status;
   begin
      Port.Configure
         (Baudrate => 100_000);
      Port.Mem_Read
         (Addr          => Addr_HAL,
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
   SDA.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
   SCL.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);

   loop
      Read_Id_HAL;
      delay 0.1;
   end loop;
end I2C_Demo;
