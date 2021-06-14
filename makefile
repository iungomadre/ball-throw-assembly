# gcc
CC=gcc
CFLAGS=-m32
LFLAGS=-L/usr/lib -lallegro
INCLUDE=-I/usr/include/allegro5

# asm
ASM=nasm
ASMFLAGS=-f elf32

# objects
COBJS=ballshooter.c
ASMOBJS=balldrawer.asm

#output name
OUT=ballshooter.out

all: asm cprog

clean:
		rm -rf *.o a.out

cprog: $(OBJS)
		$(CC) $(CFLAGS) $(COBJS) -o $(OUT) $(LFLAGS) $(INCLUDE)

asm: $(ASMOBJS)
		$(ASM) $(ASMFLAGS) -o asm.o $(ASMOBJS) 