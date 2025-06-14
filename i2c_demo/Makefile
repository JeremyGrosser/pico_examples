.PHONY: deploy build

deploy: bin/i2c_demo.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/i2c_demo.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/i2c_demo

bin/i2c_demo.uf2: bin/i2c_demo
	picotool uf2 convert bin/i2c_demo -t elf bin/i2c_demo.uf2

bin/i2c_demo: src/* *.gpr config/*
	alr build --development
