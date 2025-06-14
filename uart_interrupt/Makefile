.PHONY: deploy build

deploy: bin/uart_interrupt.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/uart_interrupt.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/uart_interrupt

bin/uart_interrupt.uf2: bin/uart_interrupt
	picotool uf2 convert bin/uart_interrupt -t elf bin/uart_interrupt.uf2

bin/uart_interrupt: src/* *.gpr config/*
	alr build --development
