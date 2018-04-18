CPU 486
BITS 32

MBOOT_PAGE_ALIGN    equ 1<<0    ; Load kernel and modules on a page boundary
MBOOT_MEM_INFO      equ 1<<1    ; Provide your kernel with memory info
MBOOT_HEADER_MAGIC  equ 0x1BADB002 ; Multiboot Magic value
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

extern kmain

global start

section .mboot
align 4
				DD			MBOOT_HEADER_MAGIC
				DD			MBOOT_HEADER_FLAGS
				DD			MBOOT_CHECKSUM

section .text
start:			CALL		kmain
				CLI
				HLT
