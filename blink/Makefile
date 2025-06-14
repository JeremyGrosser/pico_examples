.PHONY: deploy build

deploy: bin/blink.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/blink.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/blink

bin/blink.uf2: bin/blink
	picotool uf2 convert bin/blink -t elf bin/blink.uf2

bin/blink: src/* *.gpr config/*
	alr build --development
