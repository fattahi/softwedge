
# Really crappy makefile to make softwedge

DESTDIR=/usr/local/bin
DEVICE=/dev/ttyUSB0
COFLAGS?=-O2

all: libsoftwedge.a softwedge

libsoftwedge.a: sw/softwedge.c sw/softwedge.h
	$(CC) -Wall -ansi -pedantic -Isw $(COFLAGS) -c sw/softwedge.c -o sw/softwedge.o
	ar cr sw/libsoftwedge.a sw/softwedge.o

softwedge: sw/main.c sw/softwedge.h
	$(CC) -Wall -ansi -pedantic -Isw $(COFLAGS) -Lsw -o softwedge sw/main.c -lsoftwedge -lX11 -lXtst

install:
	install softwedge $(DESTDIR)

clean:
	rm -f softwedge sw/*.o sw/*.a

reindent:
	find sw -name *.[c,h] | xargs \
	indent -nbad -bap -nbc -bbo -hnl -br -brs -c33 -cd33 -ncdb -ce -ci4 \
		-cli0 -d0 -di1 -nfc1 -i8 -ip0 -l80 -lp -npcs -nprs -npsl -sai \
		-saf -saw -ncs -nsc -sob -nfca -cp33 -ss -ts8 -il1
	find sw -name *.[c,h]~ | xargs rm

valgrind: all
	valgrind --leak-check=full \
		--track-origins=yes \
		--verbose ./softwedge -c $(DEVICE) -f
