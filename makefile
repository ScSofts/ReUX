TOOL_DIR 	= ./tools
DD 			= tools\dd.bat
CCBIN 		= $(TOOL_DIR)/cc/bin/CCBIN
C++BIN		= $(TOOL_DIR)/cc/bin/C++BIN
NASM 		= $(TOOL_DIR)/nasm/nasm
NDISASM 	= $(TOOL_DIR)/nasm/ndisasm
AS 			= $(TOOL_DIR)/cc/bin/as  
LDBIN 		= $(TOOL_DIR)/cc/bin/ldbin 
OBJDUMP 	= $(TOOL_DIR)/cc/bin/objdump
BOCHS		= $(TOOL_DIR)/bochs/bochs
BOCHSDBG	= $(TOOL_DIR)/bochs/bochsdbg
OBJCOPY		= $(TOOL_DIR)/cc/bin/objcopy
EDIMG		= $(TOOL_DIR)/edimg
DEL 		= cmd /c del
BUILD		= build
CD			= cd
CLS			= cmd /c cls
ECHO		= cmd /c echo
THIS		= makefile

default : $(BUILD)/sys.img $(THIS)
	@exit 0

run : default $(THIS)
	@$(ECHO) Starting release run...
	@$(BOCHS) -f $(TOOL_DIR)/bochs/bochsrc.bxrc -q  >logs/bochs.log 2>&1
	@exit 0

debug : $(THIS)
	@$(BOCHSDBG) -f $(TOOL_DIR)/bochs/bochsrc.bxrc -q 
	@exit 0 

# NDisasm kernel
diskernel : $(THIS)
	@$(ECHO) Making kernel.dis.asm
	@$(NDISASM) -b 16 $(BUILD)/kernel.bin > $(BUILD)/kernel.dis.asm
	@exit 0

$(BUILD)/sys.img : $(BUILD)/loader.bin boot kernel $(THIS)
	@$(ECHO) =======================================================
	@$(ECHO) Making sys.img
	@$(DEL) $(BUILD)\sys.img
	@$(DD) bs=12M count=1 if=/dev/zero of=$(BUILD)/sys.img 
	@$(ECHO) =======================================================
	@$(ECHO) Copying Boot Loader
	@$(DD) bs=512 count=1 if=$(BUILD)/loader.bin of=$(BUILD)/sys.img 
	@$(ECHO) =======================================================
	@$(ECHO) Copying Kernel Loader
	

boot: $(BUILD)/boot.bin
	@$(ECHO) =======================================================
	@$(ECHO) Making boot.bin

kernel: $(BUILD)/kernel.bin $(THIS)
	@$(ECHO) =======================================================
	@$(ECHO) Making kernel.bin

include loader/makefile
include kernel/makefile