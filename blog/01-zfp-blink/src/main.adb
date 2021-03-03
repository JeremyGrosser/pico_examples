with RP2040_SVD.RESETS;     use RP2040_SVD.RESETS;
with RP2040_SVD.IO_BANK0;   use RP2040_SVD.IO_BANK0;
with RP2040_SVD.PADS_BANK0; use RP2040_SVD.PADS_BANK0;
with RP2040_SVD.SIO;        use RP2040_SVD.SIO;
with RP2040_SVD.PPB;        use RP2040_SVD.PPB;
with SysTick;

procedure Main is
    Pin_Mask   : constant GPIO_OUT_GPIO_OUT_Field := 16#0200_0000#;
    Next_Blink : Natural := 0;
begin
    RESETS_Periph.RESET.io_bank0 := False;
    RESETS_Periph.RESET.pads_bank0 := False;
    while not RESETS_Periph.RESET_DONE.io_bank0 or else
         not RESETS_Periph.RESET_DONE.pads_bank0 loop
      null;
    end loop;

    --  output disable off
    PADS_BANK0_Periph.GPIO25.OD := False;
    --  input enable off
    PADS_BANK0_Periph.GPIO25.IE := False;

    --  function select
    IO_BANK0_Periph.GPIO25_CTRL.FUNCSEL := sio_25;

     --  output enable
    SIO_Periph.GPIO_OE_SET.GPIO_OE_SET := Pin_Mask;

    SysTick.Enable;
    loop
       if SysTick.Ticks >= Next_Blink then
          SIO_Periph.GPIO_OUT_XOR.GPIO_OUT_XOR := Pin_Mask;
          Next_Blink := Next_Blink + 1_000;
       end if;
       SysTick.Wait;
    end loop;
end Main;
