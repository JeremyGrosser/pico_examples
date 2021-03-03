with RP2040_SVD.PPB; use RP2040_SVD.PPB;
--with RP2040_SVD;     use RP2040_SVD;
with System.Machine_Code;

package body SysTick is
    procedure SysTick_Handler is
    begin
       Ticks := Ticks + 1;
    end SysTick_Handler;

    procedure Enable is
    begin
        --  reload every 1ms
        PPB_Periph.SYST_RVR.RELOAD := SYST_RVR_RELOAD_Field (12_000_000 / 1_000);

        PPB_Periph.SYST_CSR :=
            (CLKSOURCE => True, --  cpu clock
             TICKINT   => True,
             ENABLE    => True,
             others    => <>);
    end Enable;

    procedure Wait is
    begin
       System.Machine_Code.Asm ("wfi", Volatile => True);
    end Wait;
end SysTick;
