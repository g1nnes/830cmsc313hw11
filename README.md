# 830cmsc313hw11
To compile + run:
nasm -f elf32 -g -F dwarf -o hw11translate2Ascii.o hw11translate2Ascii.asm
ld -m elf_i386 -o hw11translate2Ascii hw11translate2Ascii.o
./hw11translate2Ascii
