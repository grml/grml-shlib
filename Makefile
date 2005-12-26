install_ = install
name_ = grml-shlib

etc = ${DESTDIR}/etc/
usr = ${DESTDIR}/usr
usrbin = $(usr)/bin
usrsbin = $(usr)/sbin
usrshare = $(usr)/share/$(name_)
usrdoc = $(usr)/share/doc/$(name_)
man1 = $(usr)/share/man/man1/
man3 = $(usr)/share/man/man3/
man8 = $(usr)/share/man/man8/


%.html : %.txt ;
	asciidoc -b xhtml11 $^

%.gz : %.txt ;
	asciidoc -d manpage -b docbook $^
	xsltproc /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl `echo $^ |sed -e 's/.txt/.xml/'`
	gzip -f --best `echo $^ |sed -e 's/.txt//'`


all: doc

doc: doc_man doc_html

doc_html: $(name_).3.html
grml-shlib.3.html: $(name_).3.txt

doc_man: $(name_).3.gz TODO.gz
grml-shlib.3.gz: $(name_).3.txt

TODO.gz: TODO
	gzip --best -c $^ >$@


install: all
	$(install_) -d -m 755 $(usrdoc)
	$(install_) -m 644 $(name_).1.html $(usrdoc)
	$(install_) -m 644 TODO.gz $(usrdoc)

	$(install_) -d -m 755 $(man3)
	$(install_) -m 644 $(name_).1.gz $(man3)

	$(install_) -m 755 -d /etc/grml
	$(install_) -m 755 sh-lib /etc/grml

clean:
	rm -rf $(name_).1.html $(name_).1.xml $(name_).1 $(name_).1.gz

