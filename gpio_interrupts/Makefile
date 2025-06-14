.PHONY: deploy build

deploy: bin/gpio_interrupts.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/gpio_interrupts.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/gpio_interrupts

bin/gpio_interrupts.uf2: bin/gpio_interrupts
	picotool uf2 convert bin/gpio_interrupts -t elf bin/gpio_interrupts.uf2

bin/gpio_interrupts: src/* *.gpr config/*
	alr build --development
