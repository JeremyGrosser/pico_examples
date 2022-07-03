with RP.GPIO; use RP.GPIO;
with RP.Clock;
with RP.Timer;

with RP2040_SVD.I2C;
with RP.I2C;
with HAL; use HAL;
with HAL.I2C; use HAL.I2C;

with Ada.Text_IO; use Ada.Text_IO;

procedure I2C_Demo is
   SDA    : GPIO_Point := (Pin => 0);
   SCL    : GPIO_Point := (Pin => 1);
   I2C    : aliased RP.I2C.I2C_Port (0, RP2040_SVD.I2C.I2C0_Periph'Access);
   Timing : constant RP.I2C.I2C_Timing := (RP.I2C.Standard_Mode with delta Rise => 452, Fall => 10);
   Status : I2C_Status;
   Delays : RP.Timer.Delays;

   --  Read the chip ID register from a BME280/BMP280 sensor
   procedure Read_Id is
      use type RP.Timer.Time;
      Deadline : constant RP.Timer.Time := RP.Timer.Clock + RP.Timer.Milliseconds (100);
      Chip_Id  : UInt8;
   begin
      I2C.Disable (Deadline);
      if I2C.Enabled then
         Put_Line ("Disable failed, is SCL stuck low?");
         return;
      end if;
      I2C.Set_Address (HAL.UInt7'(2#1110110#));
      I2C.Enable (Deadline);
      if not I2C.Enabled then
         Put_Line ("Enable failed, is SCL stuck low?");
         return;
      end if;

      I2C.Start_Write (1, Stop => False, Deadline => Deadline);
      I2C.Write (16#D0#, Status, Deadline => Deadline);
      if Status /= Ok then
         Put_Line ("Write register address error");
         return;
      end if;

      I2C.Start_Read (1);
      I2C.Read (Chip_Id, Status, Deadline => Deadline);
      if Status /= Ok then
         Put_Line ("Read chip id error");
         return;
      end if;
      Put ("Chip Id:");
      Put (Chip_Id'Image);
      New_Line;
   end Read_Id;
begin
   RP.Clock.Initialize (12_000_000);
   SDA.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
   SCL.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
   I2C.Configure ((Role => RP.I2C.Controller, Timing => Timing));

   Delays.Enable;
   loop
      Read_Id;
      Delays.Delay_Seconds (1);
   end loop;
end I2C_Demo;
