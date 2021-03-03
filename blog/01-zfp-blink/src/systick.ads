package SysTick is

    Ticks : Natural := 0;

    procedure Enable;
    procedure Wait;

private

    procedure SysTick_Handler
       with Export        => True,
            Convention    => C,
            External_Name => "isr_systick";

end SysTick;
