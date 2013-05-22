/* File: startup_ARMCM0.S
 * Purpose: startup file for Cortex-M0 devices. Should use with 
 *   GCC for ARM Embedded Processors
 * Version: V1.4
 * Date: 09 July 2012
 * 
 * Copyright (c) 2011, 2012, ARM Limited
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the ARM Limited nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ARM LIMITED BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
/* Modified by Jared Boone, ShareBrained Technology, Inc.
 * Added: vectors for LPC11U14 peripherals
 */

    .syntax unified
    .arch armv6-m

    .section .stack
    .align 3
#ifdef __STACK_SIZE
    .equ    Stack_Size, __STACK_SIZE
#else
    .equ    Stack_Size, 0xc00
#endif
    .globl    __StackTop
    .globl    __StackLimit
__StackLimit:
    .space    Stack_Size
    .size __StackLimit, . - __StackLimit
__StackTop:
    .size __StackTop, . - __StackTop

    .section .heap
    .align 3
#ifdef __HEAP_SIZE
    .equ    Heap_Size, __HEAP_SIZE
#else
    .equ    Heap_Size, 0
#endif
    .globl    __HeapBase
    .globl    __HeapLimit
__HeapBase:
    .if    Heap_Size
    .space    Heap_Size
    .endif
    .size __HeapBase, . - __HeapBase
__HeapLimit:
    .size __HeapLimit, . - __HeapLimit
    
    .section .isr_vector
    .align 2
    .globl __isr_vector
__isr_vector:
    .long    __StackTop            /* Top of Stack */
    .long    Reset_Handler         /* Reset Handler */
    .long    NMI_Handler           /* NMI Handler */
    .long    HardFault_Handler     /* Hard Fault Handler */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    SVC_Handler           /* SVCall Handler */
    .long    0                     /* Reserved */
    .long    0                     /* Reserved */
    .long    PendSV_Handler        /* PendSV Handler */
    .long    SysTick_Handler       /* SysTick Handler */

    /* External interrupts */
    .long    pin_int0_irqhandler   /* 0x040 exception #16, IRQ #  0 */
    .long    pin_int1_irqhandler   /* 0x044 exception #17, IRQ #  1 */
    .long    pin_int2_irqhandler   /* 0x048 exception #18, IRQ #  2 */
    .long    pin_int3_irqhandler   /* 0x04c exception #19, IRQ #  3 */
    .long    pin_int4_irqhandler   /* 0x050 exception #20, IRQ #  4 */
    .long    pin_int5_irqhandler   /* 0x054 exception #21, IRQ #  5 */
    .long    pin_int6_irqhandler   /* 0x058 exception #22, IRQ #  6 */
    .long    pin_int7_irqhandler   /* 0x05c exception #23, IRQ #  7 */
    .long    gint0_irqhandler      /* 0x060 exception #24, IRQ #  8 */
    .long    gint1_irqhandler      /* 0x064 exception #25, IRQ #  9 */
    .long    0                     /* 0x068 exception #26, IRQ # 10 */
    .long    0                     /* 0x06c exception #27, IRQ # 11 */
    .long    0                     /* 0x070 exception #28, IRQ # 12 */
    .long    0                     /* 0x074 exception #29, IRQ # 13 */
    .long    ssp1_irqhandler       /* 0x078 exception #30, IRQ # 14 */
    .long    i2c_irqhandler        /* 0x07c exception #31, IRQ # 15 */
    .long    ct16b0_irqhandler     /* 0x080 exception #32, IRQ # 16 */
    .long    ct16b1_irqhandler     /* 0x084 exception #33, IRQ # 17 */
    .long    ct32b0_irqhandler     /* 0x088 exception #34, IRQ # 18 */
    .long    ct32b1_irqhandler     /* 0x08c exception #35, IRQ # 19 */
    .long    ssp0_irqhandler       /* 0x090 exception #36, IRQ # 20 */
    .long    usart_irqhandler      /* 0x094 exception #37, IRQ # 21 */
    .long    usb_irq_irqhandler    /* 0x098 exception #38, IRQ # 22 */
    .long    usb_fiq_irqhandler    /* 0x09c exception #39, IRQ # 23 */
    .long    adc_irqhandler        /* 0x0a0 exception #40, IRQ # 24 */
    .long    wwdt_irqhandler       /* 0x0a4 exception #41, IRQ # 25 */
    .long    bod_irqhandler        /* 0x0a8 exception #42, IRQ # 26 */
    .long    flash_irqhandler      /* 0x0ac exception #43, IRQ # 27 */
    .long    0                     /* 0x0b0 exception #44, IRQ # 28 */
    .long    0                     /* 0x0b4 exception #45, IRQ # 29 */
    .long    usb_wakeup_irqhandler /* 0x0b8 exception #46, IRQ # 30 */
    .long    0                     /* 0x0bc exception #47, IRQ # 31 */

    .size    __isr_vector, . - __isr_vector

    .text
    .thumb
    .thumb_func
    .align 1
    .globl    Reset_Handler
    .type    Reset_Handler, %function
Reset_Handler:
/*     Loop to copy data from read only memory to RAM. The ranges
 *      of copy from/to are specified by following symbols evaluated in 
 *      linker script.
 *      __etext: End of code section, i.e., begin of data sections to copy from.
 *      __data_start__/__data_end__: RAM address range that data should be
 *      copied to. Both must be aligned to 4 bytes boundary.  */

    ldr    r1, =__etext
    ldr    r2, =__data_start__
    ldr    r3, =__data_end__

    subs    r3, r2
    ble     .LC0

.LC1:
    subs    r3, 4
    ldr    r0, [r1,r3]
    str    r0, [r2,r3]
    bgt    .LC1
.LC0:

#ifdef __STARTUP_CLEAR_BSS
/*     This part of work usually is done in C library startup code. Otherwise,
 *     define this macro to enable it in this startup.
 *
 *     Loop to zero out BSS section, which uses following symbols
 *     in linker script:
 *      __bss_start__: start of BSS section. Must align to 4
 *      __bss_end__: end of BSS section. Must align to 4
 */
    ldr r1, =__bss_start__
    ldr r2, =__bss_end__

    subs    r2, r1
    ble .LC3

    movs    r0, 0
.LC2:
    str r0, [r1, r2]
    subs    r2, 4
    bge .LC2
.LC3:
#endif

#ifndef __NO_SYSTEM_INIT
    bl	SystemInit
#endif

#ifndef __START
#define __START _start
#endif
    bl	__START

    .pool
    .size Reset_Handler, . - Reset_Handler
    
/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
    .macro    def_default_handler    handler_name
    .align 1
    .thumb_func
    .weak    \handler_name
    .type    \handler_name, %function
\handler_name :
    b    .
    .size    \handler_name, . - \handler_name
    .endm
    
    def_default_handler    NMI_Handler
    def_default_handler    HardFault_Handler
    def_default_handler    SVC_Handler
    def_default_handler    PendSV_Handler
    def_default_handler    SysTick_Handler
    def_default_handler    Default_Handler
    def_default_handler    pin_int0_irqhandler
    def_default_handler    pin_int1_irqhandler
    def_default_handler    pin_int2_irqhandler
    def_default_handler    pin_int3_irqhandler
    def_default_handler    pin_int4_irqhandler
    def_default_handler    pin_int5_irqhandler
    def_default_handler    pin_int6_irqhandler
    def_default_handler    pin_int7_irqhandler
    def_default_handler    gint0_irqhandler
    def_default_handler    gint1_irqhandler
    def_default_handler    ssp1_irqhandler
    def_default_handler    i2c_irqhandler
    def_default_handler    ct16b0_irqhandler
    def_default_handler    ct16b1_irqhandler
    def_default_handler    ct32b0_irqhandler
    def_default_handler    ct32b1_irqhandler
    def_default_handler    ssp0_irqhandler
    def_default_handler    usart_irqhandler
    def_default_handler    usb_irq_irqhandler
    def_default_handler    usb_fiq_irqhandler
    def_default_handler    adc_irqhandler
    def_default_handler    wwdt_irqhandler
    def_default_handler    bod_irqhandler
    def_default_handler    flash_irqhandler
    def_default_handler    usb_wakeup_irqhandler

    .weak    DEF_IRQHandler
    .set    DEF_IRQHandler, Default_Handler

    .end
