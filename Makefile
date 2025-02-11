#
# Makefile for Doom
# David Cantrell <dcantrell@burdell.org>
#
# NOTE: You must gmake with this Makefile
#

OS      ?= $(shell uname -s)

CC       = gcc
LDFLAGS  =
CFLAGS   = -Wall -O -DNORMALUNIX
LIBS     = -lXext -lX11 -lm
SUBDIRS  =

OBJS     = $(O)/doomdef.o \
           $(O)/doomstat.o \
           $(O)/dstrings.o \
           $(O)/i_system.o \
           $(O)/i_video.o \
           $(O)/i_net.o \
           $(O)/i_sound.o \
           $(O)/tables.o \
           $(O)/f_finale.o \
           $(O)/f_wipe.o \
           $(O)/d_main.o \
           $(O)/d_net.o \
           $(O)/d_items.o \
           $(O)/g_game.o \
           $(O)/m_menu.o \
           $(O)/m_misc.o \
           $(O)/m_argv.o \
           $(O)/m_bbox.o \
           $(O)/m_fixed.o \
           $(O)/m_swap.o \
           $(O)/m_cheat.o \
           $(O)/m_random.o \
           $(O)/am_map.o \
           $(O)/p_ceilng.o \
           $(O)/p_doors.o \
           $(O)/p_enemy.o \
           $(O)/p_floor.o \
           $(O)/p_inter.o \
           $(O)/p_lights.o \
           $(O)/p_map.o \
           $(O)/p_maputl.o \
           $(O)/p_plats.o \
           $(O)/p_pspr.o \
           $(O)/p_setup.o \
           $(O)/p_sight.o \
           $(O)/p_spec.o \
           $(O)/p_switch.o \
           $(O)/p_mobj.o \
           $(O)/p_telept.o \
           $(O)/p_tick.o \
           $(O)/p_saveg.o \
           $(O)/p_user.o \
           $(O)/r_bsp.o \
           $(O)/r_data.o \
           $(O)/r_draw.o \
           $(O)/r_main.o \
           $(O)/r_plane.o \
           $(O)/r_segs.o \
           $(O)/r_sky.o \
           $(O)/r_things.o \
           $(O)/w_wad.o \
           $(O)/wi_stuff.o \
           $(O)/v_video.o \
           $(O)/st_lib.o \
           $(O)/st_stuff.o \
           $(O)/hu_stuff.o \
           $(O)/hu_lib.o \
           $(O)/s_sound.o \
           $(O)/z_zone.o \
           $(O)/info.o \
           $(O)/sounds.o

ifeq ($(OS),Linux)
O        = linux
CFLAGS  += -DLINUX
LDFLAGS += -L/usr/X11R6/lib
LIBS    += -lnsl
BIN      = $(O)/linuxxdoom
endif

ifeq ($(OS),A/UX)
O        = aux
CFLAGS  += -DAUX -DSNDSERV -D_POSIX_SOURCE -I./auxhelp
# A/UX divides up the system libraries by standard or addon.  libc
# comes along for the ride when you compile, but if you use a BSD or
# POSIX function, they may live in libbsd.a or libposix.a.  Use nm to
# check those libraries in /lib to figure out where the functions
# live.  libPW.a provides alloca(), for instance.  Don't worry, there
# are not many libraries in /lib to search.
LIBS    += -lPW -lbsd -lposix
BIN      = $(O)/auxdoom
SUBDIRS  = sndserv
endif

all: output $(SUBDIRS) $(BIN)

clean:
	rm -f *.o *~ *.flc
	rm -f $(O)/*
	if /bin/test -d $(O) ; then /bin/rmdir $(O) ; fi

output:
	if ! /bin/test -d $(O) ; then /bin/mkdir $(O) ; fi

$(SUBDIRS):
	$(MAKE) -C $@

# Targets
$(O)/linuxxdoom: $(OBJS) $(O)/i_main.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) $(O)/i_main.o -o $@ $(LIBS)

$(O)/auxdoom: $(OBJS) $(O)/i_main.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) $(O)/i_main.o -o $@ $(LIBS)

# Rule
$(O)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: all $(SUBDIRS)
