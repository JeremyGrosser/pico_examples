.PHONY: deploy build

deploy: bin/usb_echo.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/usb_echo.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/usb_echo

bin/usb_echo.uf2: bin/usb_echo
	picotool uf2 convert bin/usb_echo -t elf bin/usb_echo.uf2

bin/usb_echo: src/* *.gpr config/*
	alr build --development
