LOADER_ROOT = loader
$(BUILD)/loader.bin : $(LOADER_ROOT)/loader.asm $(LOADER_ROOT)/utils.asm $(THIS)
	$(NASM) -f bin -o $(BUILD)/loader.bin $(LOADER_ROOT)/loader.asm