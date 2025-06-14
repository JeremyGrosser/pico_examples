.PHONY: deploy build

deploy: bin/pio_assemble.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/pio_assemble.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/pio_assemble

bin/pio_assemble.uf2: bin/pio_assemble
	picotool uf2 convert bin/pio_assemble -t elf bin/pio_assemble.uf2

bin/pio_assemble: src/* *.gpr config/*
	alr build --development
