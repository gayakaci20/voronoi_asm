; Voronoi Diagram Generator
; Uses VGA mode 13h (320x200 pixels, 256 colors)
; Creates a diagram from 50 random points

bits 16                     ; 16-bit code
org 100h                    ; COM file format, code starts at offset 100h

; Constants
POINTS_COUNT equ 50        ; Number of random points to generate

;-------------------------------------------------------------------------------
; Data Section
;-------------------------------------------------------------------------------
section .data
start:                      ; Program entry point
        finit
        call start_graphic_mode
        call create_random_points
        call draw_voronoi
        call draw_points

wait_for_key:
        mov ah, 0
        int 16h

exit_process:
        mov ah, 4ch
        int 21h

;-------------------------------------------------------------------------------
; Drawing Functions
;-------------------------------------------------------------------------------
draw_voronoi:
        ; Draws the Voronoi diagram by coloring each pixel based on its closest point
        ; For each pixel on screen:
        ; 1. Find the closest point
        ; 2. Color the pixel based on that point's index
        ; Parameters:
        ;   al = color index
        ;   bx = y coordinate (0-199)
        ;   cx = x coordinate (0-319)
        mov al, 1              ; Start with color index 1
        mov cx, 0              ; Start at x = 0
        mov bx, 0              ; Start at y = 0
.next_pixel:
        call compute_closest_point
        
        pusha
        add al, 30
        shl al, 1
        call pset
        popa
        
        inc cx
        cmp cx, 320
        jne .next_pixel
        mov cx, 0
        inc bx
        cmp bx, 200
        jne .next_pixel
        ret

;-------------------------------------------------------------------------------
; Point Computation
;-------------------------------------------------------------------------------
compute_closest_point:
        ; Finds the closest point to the current pixel using Euclidean distance
        ; Uses FPU (Floating Point Unit) for distance calculations
        ; Input:
        ;   bx = current pixel y coordinate
        ;   cx = current pixel x coordinate
        ; Output:
        ;   al = index of the closest point (1-based)
        mov al, 0                          ; Initialize point index
        push bx
        push cx
        mov word [.cx], cx                 ; Store current x coordinate
        mov word [.cy], bx                 ; Store current y coordinate
        mov byte [.closest_index], 0       ; Initialize closest point index
        mov word [.current_distance], 0ffffh; Initialize current distance to max
        mov word [.closest_distance], 0ffffh; Initialize closest distance to max
        mov cx, POINTS_COUNT               ; Set loop counter to number of points
        mov di, 0                          ; Initialize points array index
.next:
        push cx
        
        fild word [ds:points + di + 2]     ; Load y coordinate
        fild word [.cy]                    ; Load current y
        fsub st0, st1
        fmul st0, st0
        
        fild word [ds:points + di]         ; Load x coordinate
        fild word [.cx]                    ; Load current x
        fsub st0, st1
        fmul st0, st0
        
        fadd st0, st2
        fsqrt
        
        fild word [.v100]                  ; Scale factor
        fmul st0, st1
        
        fistp word [.current_distance]
        ffree st0
        ffree st1
        ffree st2
        ffree st3
        
        mov cx, [.current_distance]
        mov bx, [.closest_distance]
        cmp cx, bx
        jnb .continue

.set_new_closest_point:
        mov [.closest_distance], cx
        mov [.closest_index], al

.continue:
        add di, 4
        pop cx
        inc al
        loop .next
        
        pop cx
        pop bx
        inc byte [.closest_index]
        mov al, [.closest_index]
        ret
.cx dw 0
.cy dw 0
.v100 dw 100
.closest_index db 0
.closest_distance dw 0
.current_distance dw 0

;-------------------------------------------------------------------------------
; Point Drawing
;-------------------------------------------------------------------------------
draw_points:
        ; Draws all points as 2x2 pixel black squares
        ; Each point is drawn in black (color 0) for visibility
        mov cx, POINTS_COUNT               ; Set loop counter
        mov di, 0                          ; Initialize points array index
.next:
        push cx
        mov al, 0
        mov cx, word [points + di]
        mov bx, word [points + di + 2]
        add di, 4
        
        pusha
        call pset
        popa
        
        pusha
        inc cx
        call pset
        popa
        
        pusha
        inc bx
        call pset
        popa
        
        pusha
        inc bx
        inc cx
        call pset
        popa
        
        pop cx
        loop .next
        ret

;-------------------------------------------------------------------------------
; Point Generation
;-------------------------------------------------------------------------------
create_random_points:
        ; Generates random points within the screen boundaries
        ; Points are stored as (x,y) pairs in the points array
        ; x coordinates range from 0-319
        ; y coordinates range from 0-199
        mov cx, POINTS_COUNT               ; Set loop counter
        mov di, 0                          ; Initialize points array index
.next:
        push cx
        
        mov bx, 320
        call generate_random_number
        mov word [points + di], dx
        add di, 2
        
        mov bx, 200
        call generate_random_number
        mov word [points + di], dx
        add di, 2
        
        pop cx
        loop .next
        ret

;-------------------------------------------------------------------------------
; Utility Functions
;-------------------------------------------------------------------------------
generate_random_number:
        ; Generates a pseudo-random number using system time
        ; Input:
        ;   bx = maximum value (exclusive)
        ; Output:
        ;   dx = random number in range [0, bx-1]
        mov ah, 0
        int 1ah                           ; Get system time (cx:dx = clock ticks)
        push cx
        push dx
        
        mov ax, dx
        mul cx
        xor ax, [.seed]
        xor dx, dx
        div bx                            ; dx = rest of division
        
        pop bx
        pop cx
        add [.seed], bx
        add [.seed], cx
        ret
.seed dw 0

start_graphic_mode:
        ; Initializes VGA mode 13h (320x200, 256 colors)
        ; Sets up ES segment to point to video memory at A000:0000
        mov ax, 0a000h                     ; Video memory segment
        mov es, ax                         ; Set ES to video segment
        mov ah, 0                          ; Function 0 - set video mode
        mov al, 13h                        ; Mode 13h - 320x200, 256 colors
        int 10h                           ; Call BIOS video interrupt
        ret

pset:
        ; Sets a pixel on the screen
        ; Input:
        ;   al = color (0-255)
        ;   bx = y coordinate (0-199)
        ;   cx = x coordinate (0-319)
        pusha                             ; Save all registers
        xor dx, dx                        ; Clear DX for multiplication
        push ax                           ; Save color
        mov ax, 320                       ; Screen width
        mul bx                            ; Calculate y * 320
        add ax, cx                        ; Add x offset
        mov bx, ax                        ; Move offset to BX
        pop ax                            ; Restore color
        mov byte [es:bx], al              ; Write pixel to video memory
        popa                              ; Restore all registers
        ret

;-------------------------------------------------------------------------------
; BSS Section
;-------------------------------------------------------------------------------
section .bss
points resw POINTS_COUNT * 2               ; Array to store point coordinates
	