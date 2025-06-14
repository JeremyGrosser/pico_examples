.PHONY: deploy build

deploy: bin/adc_hello.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/adc_hello.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/adc_hello

bin/adc_hello.uf2: bin/adc_hello
	picotool uf2 convert bin/adc_hello -t elf bin/adc_hello.uf2

bin/adc_hello: src/* *.gpr config/*
	alr build --development
