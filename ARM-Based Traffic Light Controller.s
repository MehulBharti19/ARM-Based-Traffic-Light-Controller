.syntax unified
    .cpu cortex-a9
    .fpu neon
    .text
    .global _start

    .equ LEDR_BASE,   0xFF200000
    .equ HEX3_0_BASE, 0xFF200020
    .equ HEX5_4_BASE, 0xFF200030

    .equ NS_R, (1<<0)
    .equ NS_Y, (1<<1)
    .equ NS_G, (1<<2)
    .equ EW_R, (1<<3)
    .equ EW_Y, (1<<4)
    .equ EW_G, (1<<5)

    .equ PHASE_GO,     150
    .equ PHASE_YELLOW, 30
    .equ DELAY_1S, 9000000

    .section .rodata
    .align 4
digits: .byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F
blank:  .byte 0x00

    .text

_start:
    LDR r8, =LEDR_BASE
    LDR r9, =HEX3_0_BASE
    LDR r10,=HEX5_4_BASE

loop:
    MOV r0, #PHASE_GO
    BL  lights_NSred_EWgreen
    BL  countdown_phase

    MOV r0, #PHASE_YELLOW
    BL  lights_all_YELLOW
    BL  countdown_phase

    MOV r0, #PHASE_GO
    BL  lights_EWred_NSgreen
    BL  countdown_phase

    MOV r0, #PHASE_YELLOW
    BL  lights_all_YELLOW
    BL  countdown_phase
    B   loop

lights_NSred_EWgreen:
    MOV r1, #(NS_R|EW_G)
    STR r1, [r8]
    BX  lr

lights_EWred_NSgreen:
    MOV r1, #(EW_R|NS_G)
    STR r1, [r8]
    BX  lr

lights_all_YELLOW:
    MOV r1, #(NS_Y|EW_Y)
    STR r1, [r8]
    BX  lr

countdown_phase:
    PUSH {r4-r7, lr}
    MOV  r4, r0
1:
    MOV  r0, r4
    BL   hex_show_mmss
    BL   delay_1s
    SUBS r4, r4, #1
    BPL  1b
    MOV  r0, #0
    BL   hex_show_mmss
    POP  {r4-r7, lr}
    BX   lr

hex_show_mmss:
    PUSH {r4-r7, lr}
    MOV  r1, #60
    BL   udiv
    MOV  r6, r1
    MOV  r1, #10
    BL   udiv
    LDR  r7, =digits
    ADD  r4, r7, r0
    LDRB r4, [r4]
    ADD  r5, r7, r1
    LDRB r5, [r5]
    MOV  r0, r6
    MOV  r1, #10
    BL   udiv
    LDR  r7, =digits
    ADD  r2, r7, r0
    LDRB r2, [r2]
    ADD  r3, r7, r1
    LDRB r3, [r3]
    LDR  r7, =blank
    LDRB r1, [r7]
    MOV  r0, r3
    ORR  r0, r0, r2, LSL #8
    ORR  r0, r0, r1, LSL #16
    ORR  r0, r0, r1, LSL #24
    STR  r0, [r9]
    MOV  r0, r5
    ORR  r0, r0, r4, LSL #8
    STR  r0, [r10]
    POP  {r4-r7, lr}
    BX   lr

udiv:
    PUSH {r2-r3, lr}
    MOV  r2, #0
    MOV  r3, r0
1:  CMP  r3, r1
    BLT  2f
    SUB  r3, r3, r1
    ADD  r2, r2, #1
    B    1b
2:  MOV  r0, r2
    MOV  r1, r3
    POP  {r2-r3, lr}
    BX   lr

delay_1s:
    PUSH {r1, lr}
    LDR  r1, =DELAY_1S
1:  SUBS r1, r1, #1
    BNE  1b
    POP  {r1, lr}
    BX   lr