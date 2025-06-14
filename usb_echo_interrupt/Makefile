.PHONY: deploy build

deploy: bin/usb_echo_interrupt.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/usb_echo_interrupt.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/usb_echo_interrupt

bin/usb_echo_interrupt.uf2: bin/usb_echo_interrupt
	picotool uf2 convert bin/usb_echo_interrupt -t elf bin/usb_echo_interrupt.uf2

bin/usb_echo_interrupt: src/* *.gpr config/*
	alr build --development
