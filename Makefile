.PHONY: all everything copybin debug clean install uninstall check

prefix=/usr/local
exec_prefix=$(prefix)
bindir=$(exec_prefix)/bin
datarootdir=$(prefix)/share
mandir=$(datarootdir)/man
man1dir=$(mandir)/man1

INSTALL=install
INSTALL_PROGRAM=$(INSTALL)
INSTALL_DATA=$(INSTALL) -m 644

sinclude config.inc

all: everything copybin

everything:
	$(MAKE) $(T) --directory=common
	$(MAKE) $(T) --directory=stuncore
	$(MAKE) $(T) --directory=networkutils
	$(MAKE) $(T) --directory=testcode
	$(MAKE) $(T) --directory=client
	$(MAKE) $(T) --directory=server

copybin: everything
	rm -f ./stunserver ./stunclient ./stuntestcode
	cp server/stunserver .
	cp client/stunclient .
	cp testcode/stuntestcode .


install: everything resources/stunserver.1 resources/stunclient.1
	mkdir -p $(DESTDIR)$(bindir) $(DESTDIR)$(man1dir)
	cd server && $(INSTALL_PROGRAM) stunserver $(DESTDIR)$(bindir)
	cd client && $(INSTALL_PROGRAM) stunclient $(DESTDIR)$(bindir)
	cd resources && $(INSTALL_DATA) stunserver.1 $(DESTDIR)$(man1dir)
	cd resources && $(INSTALL_DATA) stunclient.1 $(DESTDIR)$(man1dir)

uninstall:
	rm -f \
		$(DESTDIR)$(bindir)/stunserver \
		$(DESTDIR)$(bindir)/stunclient \
		$(DESTDIR)$(man1dir)/stunserver.1 \
		$(DESTDIR)$(man1dir)/stunclient.1

check: everything
	testcode/stuntestcode


debug: T := debug
debug: all

profile: T := profile
profile: all

pgo1: T := pgo1
pgo1: all

pgo2: T := pgo2
pgo2: all

clean:	T := clean
clean: everything
	rm -f stunserver stunclient stuntestcode

distclean: clean
	rm -f config.inc config.status

