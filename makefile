CC=gcc
ASM=nasm


all: main.o drawball.o
		$(CC) main.o drawball.o -o ballshooter -lallegro -lallegro_font

main.o: main.c
		$(CC) -c main.c -o main.o

drawball.o: drawball.asm
		$(ASM) -f elf64 -g drawball.asm

clean:
		rm -rf *.o

run: all clean
	./ballshooter
