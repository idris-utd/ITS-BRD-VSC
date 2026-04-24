    EXTERN initITSboard
    EXPORT main

PERIPH_BASE         equ 0x40000000
AHB1PERIPH_BASE     equ (PERIPH_BASE + 0x00020000)
GPIOD_BASE          equ (AHB1PERIPH_BASE + 0x0C00)

GPIO_D_SET          equ (GPIOD_BASE + 0x18)

    AREA  |.text|, CODE, READONLY, ALIGN = 3
    ALIGN

main
    BL initITSboard
    nop

    LDR     R6, =GPIO_D_SET

    MOV     R4, #0x03       ; D08 + D09 einschalten
    STRB    R4, [R6]

    b .

    ALIGN
    END

