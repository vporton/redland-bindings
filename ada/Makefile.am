# -*- Mode: Makefile -*-
#
# Makefile.am - automake file for Ada2012 interface to Redland
#
# Copyright (C) 2014 Victor Porton - http://freesoft.portonvictor.org/
# 
# This package is Free Software and part of Redland http://librdf.org/
# 
# It is licensed under the following three licenses as alternatives:
#   1. GNU Lesser General Public License (LGPL) V2.1 or any newer version
#   2. GNU General Public License (GPL) V2 or any newer version
#   3. Apache License, V2.0 or any newer version
# 
# You may not use this file except in compliance with at least one of
# the above three licenses.
# 
# See LICENSE.html or LICENSE.txt at the top of this package for the
# full license terms.
# 
# 

soversion = 2.0.14
soname = librdf-ada.so.$(soversion)

ADAINCLUDE = $(includedir)/librdf
ADALIB = $(libdir)/librdf

LIB_DIR = $(srcdir)/lib

lib/librdf-ada.so:
	gnatmake -p -Plibrdf.gpr \
                 -XLIBRARY_KIND=dynamic -XOBJ_DIR=$(builddir)/obj -Xsoversion=$(soname)

lib/librdf-ada.a:
	gnatmake -p -Plibrdf.gpr \
		 -XLIBRARY_KIND=static -XOBJ_DIR=$(builddir)/obj -Xsoversion=$(soname)

all: $(LIB_DIR)/librdf-ada.so $(LIB_DIR)/librdf-ada.a

clean:
	gnat clean -r -Plibrdf.gpr -XLIBRARY_KIND=dynamic -XOBJ_DIR=$(builddir)/obj -Xsoversion=$(soname)
	gnat clean -r -Plibrdf.gpr -XLIBRARY_KIND=static -XOBJ_DIR=$(builddir)/obj -Xsoversion=$(soname)
	gnat clean -r -Ptest.gpr -XLIBRARY_KIND=dynamic -XOBJ_DIR=$(builddir)/obj/test -Xsoversion=$(soname)
	gnat clean -r -Ptest.gpr -XLIBRARY_KIND=static -XOBJ_DIR=$(builddir)/obj/test -Xsoversion=$(soname)
	rm -f $(builddir)/lib/$(soname)

install: all
	mkdir -p $(ADAINCLUDE)
	mkdir -p $(ADALIB)
	mkdir -p $(libdir)
	cd $(srcdir)/src && $(INSTALL_DATA) *.ads *.adb $(ADAINCLUDE)
	cd $(builddir)/ali && $(INSTALL_DATA) *.ali $(ADALIB)
	$(INSTALL_DATA) lib/librdf-ada.so lib/librdf-ada.a $(soname) $(libdir)


uninstall:
	rm -rf $(ADAINCLUDE)
	rm -rf $(ADALIB)
	cd $(builddir)/lib && rm -f librdf-ada.so librdf-ada.a $(soname)

.PHONY: all clean install uninstall