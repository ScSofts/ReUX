
[BITS 16]      ; 16 bit code generation
[ORG 0x7C00]   ; Origin location
%include "loader/utils.asm";include marco defines

;=====================FAT32 Head====================
head:
	jmp main					;went to the main program
	nop							;fill the space

	OEM_ID                db 		"ReUX OS",0
	BytesPerSector        dw 		0x0200
	SectorsPerCluster     db 		0x08
	ReservedSectors       dw 		0x0020
	TotalFATs             db 		0x02
	MaxRootEntries        dw 		0x0000
	NumberOfSectors       dw 		0x0000
	MediaDescriptor       db 		0xf8
	SectorsPerFAT         dw 		0x0000
	SectorsPerTrack       dw 		0x003d
	SectorsPerHead        dw 		0x0002
	HiddenSectors         dd 		0x00000000
	TotalSectors     	  dd 		0x00fe3b1f		
	BigSectorsPerFAT      dd 		0x00000778
	Flags                 dw 		0x0000
	FSVersion             dw 		0x0000
	RootDirectoryStart    dd 		0x00000002
	FSInfoSector          dw 		0x0001
	BackupBootSector      dw 		0x0006

	times 12 db 0 				;jumping to next offset

	DriveNumber           db 		0x00
	ReservedByte          db   		0x00
	Signature             db 		0x29
	VolumeID              dd 		0x3d400fbf
	VolumeLabel           db 		"ReUX OS",0,0,0,0
	SystemID              db 		"FAT32   "

; ===================== Main program==================
main:
	;init registers
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov fs,ax
	mov sp,0x7c00
	
	Clear						;Clear the screen
	SetCursor 0,0,0				;Return the cursor to line 0 col 0
	Puts Loading				;Print the string to the screen
	SetCursor 0,1,0				;Go to next line
	mov si,0					;ReadErr Times

	mov di,0					;Read Offset
	jmp .readLoop
.errorOnce:
	add si,1
	cmp si,5
	je .failed
.readLoop:
	; %1 = disk to read
	;,%2 = sector count ( represent the size to read )
	
	;,%3 = cylinder
	;,%4 = sector
	;,%5 = head
	
	;,%6 = ES = address to flush start
	;,%7 = BX = address to flush end
	mov ax,0x0820
	add ax,di
	mov es,ax

	mov ax,2
	add ax,di
	ReadDisk 0x80,1h, 0,al,0 ,es,0
	jc .errorOnce
	add di,1h
	cmp di,6
	je .success
.success:
	Puts Succeed
	jmp 0x0820
	jmp end_program
.failed:
	Puts Failed
;main end
end_program:
		Pause 					;Stop the program

PutsImpl
data:
	Loading: db "Loading from hard disk...",13,0
	Failed:  db "Read Disk failed!",0
	Succeed: db "Loading succeed!",0
times 510-($-$$) db 0			; Fill the rest with zeros
dw 0xAA55						; Boot loader signature
