;pause the program
%macro Pause 0
	loop:
        hlt
	    jmp loop
%endmacro

;00H 40×25x16 Text  01H 40×25x16 Text
;02H 80×25x16 Text  03H 80×25x16 Text
;04H 320×200x4      05H 320×200x4
;06H 640×200x2      07H 80×25x2  Text
;08H 160×200x16     09H 320×200x16
;0AH 640×200x4      0BH (null)　
;0CH (null)         0DH 320×200x16
;0EH 640×200x16     0FH 640×35x02(Single Color)
;10H 640×350x4      10H 640×350x16
;11H 640×480x2      12H 640×480x16
;13H 640×480x256
%macro SetDisplayer 1;%1 = display mode
    mov ah,0x00
    mov al,%1
    int 0x10
%endmacro
;set the cursor position
%macro SetCursor 3 ;%1 = page code , %2 = line , %3 = col
    mov ah,0x02
    mov bh,%1
    mov dh,%2
    mov dl,%3
    int 10h
%endmacro

;get the cursor position
;CH = cursor start line
;CL = cursor end line
;DH = line
;DL = col
%macro GetCursor 1;%1 = page code
    mov ah,0x03
    mov bh,%1
    int 0x10
%endmacro

%macro SetDisplayPage 1;%1 = page code
    mov ah,0x05
    mov al,%1
    int 0x10
%endmacro

%macro Clear 0
    mov ah,0x06
    mov bh,0x7
    mov cx,0
    mov dx,0xffff
    int 0x10
%endmacro

%macro DrawPoint 2-3 0h; %1 = x,%2 = y [,%3 = page code]
    mov ah,0x0d
    mov cx,%1
    mov dx,%2
    mov dh,%3
    int 0x10
%endmacro

;%1:
;   0x00 the first floppy
;   0x01 the second floppy
;   ...
;   0x80 the first hard disk
;   ...
;   0xE0 DVD/CD
;Returns:
;AH:
;   0x00 success
;   0x01 illegal instruction
;   0x03 write protected
;   0x04 sector doesn't exist
;   0x05 rest failed
;   0x0A sector isn't good
;   0x0B cylinder isn't good
;   0x0D illegal sector count
;   0x20 disk controller crashed
;   0x80,0xAA disk controller isn't ready
%macro ResetDisk 1;%1 = disk to read
mov ah,0x00
mov dl,%1
int 0x13
%endmacro

%macro ReadDisk 7 ; %1 = disk to read
                  ;,%2 = sector count ( represent the size to read )
                  
                  ;,%3 = cylinder
                  ;,%4 = sector
                  ;,%5 = head
                  
                  ;,%6 = ES = address to flush start
                  ;,%7 = BX = address to flush end
mov dl,%1
mov al,%2
mov ch,%3
mov cl,%4
mov dh,%5
mov es,%6
mov bx,%7
mov ah,0x02
int 0x13
%endmacro


%macro Puts 1;%1 = string address
mov si,%1
    .strloop:
        mov     al,[si]
        add     si,1
        cmp     al,0
        je      .end
        mov		ah,0x0e			
        mov		bx,15		
        int		0x10
        jmp .strloop
    .end:
%endmacro