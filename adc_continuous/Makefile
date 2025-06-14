.PHONY: deploy build

deploy: bin/adc_continuous.uf2
	@echo "Hold bootsel button on pico while you plug in the USB cable and press any key to continue. You can release the bootsel while Loading into Flash."
	@read anykey
	picotool load bin/adc_continuous.uf2
	@echo "Now reboot the device by replugging the USB cable."

build: bin/adc_continuous

bin/adc_continuous.uf2: bin/adc_continuous
	picotool uf2 convert bin/adc_continuous -t elf bin/adc_continuous.uf2

bin/adc_continuous: src/* *.gpr config/*
	alr build --development
