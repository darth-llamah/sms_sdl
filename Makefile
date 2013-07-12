
# Makefile for sms+sdl
#
# Copyright (C) 1998, 1999, 2000  Charles Mac Donald
# SDL version by Gregory Montoir <cyx@frenchkiss.net>
#
# Defines :
# LSB_FIRST : for little endian systems.
# X86_ASM   : enable x86 assembly optimizations
# USE_ZLIB  : enable ZIP file support

NAME	  = sms_sdl
CC        = mipsel-linux-gcc
SYSROOT:=$(shell mipsel-gcw0-linux-uclibc-gcc --print-sysroot)
SDL_CFLAGS:=$(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS:=$(shell $(SYSROOT)/usr/bin/sdl-config --libs)
CFLAGS    = $(SDL_CFLAGS) -Winline -mabi=32 -mips32 -mtune=mips32 -O3 -fstrength-reduce -fthread-jumps -fexpensive-optimizations -fomit-frame-pointer -frename-registers -pipe -G 0 -ffast-math #-fprofile-use
DEFINES   = -DLSB_FIRST -DALIGN_DWORD
INCLUDES  = -I. -Ibase -Icpu -Isound -I/opt/mipsel-linux-uclibc/usr/include/SDL
LIBS	  = -lSDL -lz -lm -lpthread #-lgcov

OBJECTS   = main.o saves.o settingsdir.o sdlsms.o \
            base/render.o base/sms.o base/system.o base/vdp.o \
            cpu/z80.o sound/emu2413.o sound/sn76496.o

# (un)comment to enable ZIP support
DEFINES  += -DUSE_ZLIB
#LIBS     += -Lz
OBJECTS  += unzip.o


all: $(NAME)

$(NAME): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -o bin/$@

.c.o:
	$(CC) -c $(CFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

clean:
	rm -f $(OBJECTS) bin/$(NAME)
