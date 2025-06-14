.PHONY: deploy build

deploy: bin/uart_echo.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/uart_echo.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/uart_echo

bin/uart_echo.uf2: bin/uart_echo
	picotool uf2 convert bin/uart_echo -t elf bin/uart_echo.uf2

bin/uart_echo: src/* *.gpr config/*
	alr build --development
