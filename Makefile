INSTALL	?= install
MKDIR	?= mkdir
CP		?= cp
CHOWN	?= chown

DESTDIR ?= ./rootfs

all:

directory-tree:
	$(MKDIR) -p $(DESTDIR)/{bin,sbin,etc,dev,lib/modules,mnt,proc,run,sys,tmp}
	$(CHOWN) 1777 $(DESTDIR)/tmp

install-www:
	$(CP) -R www $(DESTDIR)
	
install-kit:
	$(INSTALL) -D -m 755 src/init $(DESTDIR)/init
	$(INSTALL) -D -m 755 src/shutdown $(DESTDIR)/shutdown
	$(INSTALL) -D -m 644 src/colibrikitlib $(DESTDIR)/lib/colibrikitlib
	$(INSTALL) -D -m 644 src/colibriwebui $(DESTDIR)/lib/colibriwebui
	$(INSTALL) -D -m 644 src/config $(DESTDIR)/lib/.config
	$(INSTALL) -D -m 644 src/httpd.conf $(DESTDIR)/etc/httpd.conf

install: directory-tree install-www install-kit
	@echo
	@echo "* EarlyBoot kit installed to $(DESTDIR)"
