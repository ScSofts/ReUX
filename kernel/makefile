ROOT = kernel

$(BUILD)/kernel.bin : $(ROOT)/kernel.c $(THIS)
	$(CCBIN) $(ROOT)/kernel.c -o $(BUILD)/kernel.o
	$(LDBIN) 0x00 -o $(BUILD)/kernel.32 -s --entry _kernel_main $(BUILD)/kernel.o
	$(OBJCOPY) -O binary -S $(BUILD)/kernel.32 $(BUILD)/kernel.bin
	$(DEL) $(BUILD)\kernel.32