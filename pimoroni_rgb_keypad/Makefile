.PHONY: deploy build

deploy: bin/pimoroni_rgb_keypad.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/pimoroni_rgb_keypad.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/pimoroni_rgb_keypad

bin/pimoroni_rgb_keypad.uf2: bin/pimoroni_rgb_keypad
	picotool uf2 convert bin/pimoroni_rgb_keypad -t elf bin/pimoroni_rgb_keypad.uf2

bin/pimoroni_rgb_keypad: src/* *.gpr config/*
	alr build --development
