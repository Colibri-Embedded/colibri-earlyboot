INSTALL	?= install
MKDIR	?= mkdir
CP		?= cp
CHMOD	?= chmod

DESTDIR ?= ./rootfs

all:

directory-tree:
#	$(MKDIR) -p $(DESTDIR)/{bin,sbin,etc/init.d,dev,lib/modules,mnt,proc,run,sys,tmp}
	$(MKDIR) -p $(DESTDIR)/bin
	$(MKDIR) -p $(DESTDIR)/sbin
	$(MKDIR) -p $(DESTDIR)/etc/init.d
	$(MKDIR) -p $(DESTDIR)/dev
	$(MKDIR) -p $(DESTDIR)/lib/modules
	$(MKDIR) -p $(DESTDIR)/mnt
	$(MKDIR) -p $(DESTDIR)/proc
	$(MKDIR) -p $(DESTDIR)/run
	$(MKDIR) -p $(DESTDIR)/sys
	$(MKDIR) -p $(DESTDIR)/tmp
	$(CHMOD) 1777 $(DESTDIR)/tmp

install-www:
	$(CP) -aRv www $(DESTDIR)/
	
install-kit:
	$(INSTALL) -D -m 755 src/init $(DESTDIR)/init
	$(INSTALL) -D -m 755 src/shutdown $(DESTDIR)/sbin/init
	$(INSTALL) -D -m 755 src/rc_empty $(DESTDIR)/etc/init.d/rc
	$(INSTALL) -D -m 644 src/colibrikitlib $(DESTDIR)/lib/colibrikitlib
	$(INSTALL) -D -m 755 src/mkusers $(DESTDIR)/sbin/mkusers
	$(INSTALL) -D -m 644 src/colibriwebui $(DESTDIR)/lib/colibriwebui
	$(INSTALL) -D -m 644 src/config $(DESTDIR)/lib/.config
	$(INSTALL) -D -m 644 src/httpd.conf $(DESTDIR)/etc/httpd.conf

install: directory-tree install-www install-kit
	@echo
	@echo "* EarlyBoot kit installed to $(DESTDIR)"
