# TODO: Take --enable-shared --enable-static into account
all-local: librdf_dlang.a librdf_dlang.so

my-check: rdf_dlang
	./rdf_dlang $(srcdir)

check: my-check

clean-local:
	$(DUB) clean
	rm -f librdf_dlang.a librdf_dlang.so rdf_dlang

lib_LIB = librdf_dlang.a librdf_dlang.so

if DEBUG
buildflags = --build=debug
else
buildflags = --build=release
endif

.PHONY: librdf_dlang.a librdf_dlang.so rdf_dlang

librdf_dlang.a:
	$(DUB) build --compiler=$(DC) --config=static-library $(buildflags)

librdf_dlang.so:
	$(DUB) build --compiler=$(DC) --config=shared-library $(buildflags)

rdf_dlang:
	$(DUB) build --compiler=$(DC) --config=application --build=unittest

dist-hook:
	cp -a source $(distdir)/
	find $(distdir)/source \! -name "*.d" \! -type d | xargs rm -f

install-data-local:
	mkdir -p $(libdir)
	install librdf_dlang.a librdf_dlang.so $(libdir)
	mkdir -p $(includedir)/d/librdf
	cd $(srcdir)/source && cp --parents `find -name "*.d" \! -name main.d` $(includedir)/d/librdf/
	cat dub-install.json | sed 's%INLCUDEDIR%$(includedir)%g; s|$${prefix}|@prefix@|g' > $(includedir)/d/librdf/dub.json
