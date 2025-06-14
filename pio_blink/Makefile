.PHONY: deploy build

deploy: bin/pio_blink.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/pio_blink.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/pio_blink

bin/pio_blink.uf2: bin/pio_blink
	picotool uf2 convert bin/pio_blink -t elf bin/pio_blink.uf2

bin/pio_blink: src/* *.gpr config/*
	alr build --development
