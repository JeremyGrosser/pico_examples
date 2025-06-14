.PHONY: deploy build

deploy: bin/pwm.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/pwm.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/pwm

bin/pwm.uf2: bin/pwm
	picotool uf2 convert bin/pwm -t elf bin/pwm.uf2

bin/pwm: src/* *.gpr config/*
	alr build --development
