INSTALL	?= install
MKDIR	?= mkdir
CP		?= cp
CHMOD	?= chmod

DESTDIR ?= ./rootfs

all:

directory-tree:
	$(MKDIR) -p $(DESTDIR)/{bin,sbin,etc/init.d,dev,lib/modules,mnt,proc,run,sys,tmp}
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
