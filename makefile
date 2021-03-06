# Compiling gcl:
#   ./configure
#   make
# For more details see the file readme

prefix=/usr/local
# This would cause make install to create /usr/local/bin/gcl and
# /usr/local/lib/gcl-x.yy/* with some basic files.
# This prefix may be overridden e.g. with
# ./configure --prefix=/usr/share

# Allow platform defs file to override this.
TK_LISP_LIB=gcl-tk/tkl.o gcl-tk/tinfo.o gcl-tk/decode.tcl gcl-tk/demos/*.lsp gcl-tk/demos/*.lisp gcl-tk/demos/*.o
TCL_EXES=gcl-tk/gcl.tcl gcl-tk/gcltkaux$(EXE)

GCL_DVI=gcl-tk.dvi gcl-si.dvi gcl.dvi
GCL_HTML=gcl-si_toc.html gcl-tk_toc.html gcl_toc.html

-include makedefs


BINDIR	= bin
HDIR	= h/
CDIR	= c
ODIR	= o
LSPDIR	= lsp
CMPDIR	= cmpnew
PORTDIR	= unixport
CLCSDIR = clcs
PCLDIR = pcl
MPDIR	= mp
TESTDIR = ansi-tests
#GMP_DIR = gmp3/

VERSION=`cat majvers`.`cat minvers`

all: $(BUILD_BFD) system command cmpnew/gcl_collectfn.o lsp/gcl_info.o do-gcl-tk # do-info

ASRC:=$(shell ls -1 o/*.c lsp/*.lsp cmpnew/*.lsp mod/*.lsp pcl/*sp clcs/*sp xgcl-2/*p) #o/*.d o/*.h h/*.h
TAGS: $(ASRC)
	etags --regex='/\#.`(defun[ \n\t]+\([^ \n\t]+\)/' $^

system: $(PORTDIR)/$(FLISP)
#	[ "$(X_LIBS)" == "" ] || (cd xgcl-2 && make saved_xgcl LISP=../$< && mv saved_xgcl ../$(PORTDIR)/$(FLISP))
	touch $@

xgcl: $(PORTDIR)/saved_xgcl

$(PORTDIR)/saved_xgcl: $(PORTDIR)/saved_gcl
	cd xgcl-2 && $(MAKE)

#binutils/intl/libintl.a:
#	cd $(@D) && $(MAKE)

#binutils/bfd/libbfd.a binutils/libiberty/libiberty.a: binutils/intl/libintl.a
#	cd $(@D) && $(MAKE)

copy_iberty: $(LIBIBERTY)
	mkdir -p binutils/libiberty && cd binutils/libiberty && ar x $<

copy_bfd: $(LIBBFD) copy_iberty
	mkdir -p binutils/bfd && cd binutils/bfd && ar x $<

#h/bfd.h: binutils/bfd/libbfd.a binutils/libiberty/libiberty.a
#	cp $(<D)/$(@F) $@

#h/bfdlink.h h/ansidecl.h h/symcat.h: binutils/bfd/libbfd.a binutils/libiberty/libiberty.a
#	cp $(<D)/../include/$(@F) $@

$(PORTDIR)/saved_pre_gcl: $(HDIR)cmpinclude.h
	(cd $(BINDIR); $(MAKE) all)
	$(MAKE) mpfiles
	rm -f o/cmpinclude.h ; cp h/cmpinclude.h o
	(cd $(ODIR); $(MAKE) all)
	$(MAKE) $<
	rm -f o/cmpinclude.h ; cp h/cmpinclude.h o
	(cd $(ODIR); $(MAKE) all)
	cd $(@D) && $(MAKE) $(@F)

$(PORTDIR)/saved_gcl: $(PORTDIR)/saved_pre_gcl $(HDIR)cmpinclude.h 
	(cd $(LSPDIR); touch *.lsp ; $(MAKE) all)
	(cd $(CMPDIR); touch *.lsp ; $(MAKE) all)
	[ -z "$(X_LIBS)" ] || (cd xgcl-2 && $(MAKE) LISP=../$<)
	cd $(@D) && $(MAKE) $(@F)

$(PORTDIR)/saved_pcl_gcl: $(PORTDIR)/saved_gcl
	(cd $(PCLDIR); rm -f *.c; $(MAKE) all)
	cd $(@D) && $(MAKE) $(@F)

$(PORTDIR)/saved_ansi_gcl: $(PORTDIR)/saved_pcl_gcl
	(cd $(CLCSDIR); rm -f *.c; $(MAKE) all)
	cd $(@D) && $(MAKE) $(@F)

ansi-tests/test_results: $(PORTDIR)/saved_ansi_gcl
	cd $(@D) && rm -f *.o rt/*.o && echo '(load "gclload.lsp")' | ../$<  2>&1 |tee $(@F) & j=$$! ; \
		tail -f --pid=$$j --retry $@ & wait $$j

#$(PCLDIR)/saved_gcl_pcl: $(PORTDIR)/saved_gcl
#	cd $(@D) &&  $(MAKE) compile LISP="../$<" &&  $(MAKE) $(@F) LISP="../$<"

#$(CLCSDIR)/saved_full_gcl: $(PCLDIR)/saved_gcl_pcl
#	cd $(@D) &&  $(MAKE) compile LISP="../$<" &&  $(MAKE) $(@F) LISP="../$<"

#$(PORTDIR)/saved_ansi_gcl: $(CLCSDIR)/saved_full_gcl
#	cd $(@D) &&  $(MAKE) $(@F)

cmpnew/gcl_collectfn.o lsp/gcl_info.o:
	cd $(@D) && $(MAKE) $(@F)

do-gcl-tk:
	if [ -d "$(TK_CONFIG_PREFIX)" ] ; then \
		cd gcl-tk && $(MAKE) ; \
	else \
		echo "gcl-tk not made..missing include or lib" ; \
	fi 

do-info:
	cd info && $(MAKE)

mpfiles: $(MPFILES)

$(MPDIR)/libmport.a:
	(cd mp ; $(MAKE) all)

$(GMPDIR)/libgmp.a: $(GMPDIR)/Makefile
	cd $(GMPDIR) && $(MAKE) && rm -f libgmp.a &&  ar qc libgmp.a *.o */*.o

PWD_CMD?=pwd

gmp_all: $(GMPDIR)/Makefile
	cd $(GMPDIR) && echo '#include <stdio.h>' >> gmp.h && echo "#include \"`$(PWD_CMD)`/../h/prelink.h\"" >> gmp.h && $(MAKE) 
	touch $@

$(GMPDIR)/mpn/mul_n.o $(GMPDIR)/mpn/lshift.o $(GMPDIR)/mpn/rshift.o: $(GMPDIR)/Makefile
	cd $(@D) && $(MAKE) $(@F)

command:
	rm -f bin/gcl xbin/gcl
	MGCLDIR=`echo $(GCLDIR) | sed -e 'sX^\([a-z]\):X/\1Xg'` ; \
	GCLDIR=`echo $(GCLDIR)` ; \
	$(MAKE) install-command "INSTALL_LIB_DIR=$$GCLDIR" "prefix=$$GCLDIR" "BINDIR=$$MGCLDIR/$(PORTDIR)"
	(cd xbin ; cp ../bin/gcl .)

#	GCLDIR=`echo $(GCLDIR) | sed -e 'sX^/cygdrive/\([a-z]\)X\1!Xg' -e 'sX^//\([a-z]\)X\1!Xg'` ; \

merge:
	$(CC) -o merge merge.c

LISP_LIB=cmpnew/gcl_collectfn.o cmpnew/gcl_collectfn.lsp xgcl-2/sysdef.lisp xgcl-2/gcl_dwtest.lsp xgcl-2/gcl_dwtestcases.lsp lsp/gcl_gprof.lsp lsp/gcl_info.o lsp/gcl_profile.lsp lsp/gcl_export.lsp lsp/gcl_autoload.lsp cmpnew/gcl_cmpmain.lsp cmpnew/gcl_cmpopt.lsp cmpnew/gcl_lfun_list.lsp lsp/gcl_auto_new.lsp h/cmpinclude.h unixport/init_$(SYSTEM).lsp unixport/lib$(SYSTEM).a unixport/libgclp.a gcl-tk/tk-package.lsp $(TK_LISP_LIB) $(RL_LIB) $(FIRST_FILE) $(LAST_FILE) $(addsuffix /sys-proclaim.lisp,lsp cmpnew pcl clcs) unixport/gcl.script

install-command:
	rm -f $(DESTDIR)$(prefix)/bin/gcl
	(echo '#!/bin/sh' ; \
	echo exec $(BINDIR)/$(FLISP)$(EXE) \\ ; \
	echo '   -dir' $(INSTALL_LIB_DIR)/unixport/ \\ ; \
	echo '   -libdir' $(INSTALL_LIB_DIR)/ \\ ; \
	echo '   -eval '\''(setq si::*allow-gzipped-file* t)'\' \\ ;\
	! [ -d "$(TK_CONFIG_PREFIX)" ] || echo '   -eval '\''(setq si::*tk-library* '\"$(TK_LIBRARY)\"')'\' \\;\
	echo '     '\"\$$@\" ) > $(DESTDIR)$(prefix)/bin/gcl;
	echo '#' other options: -load "/tmp/foo.o" -load "jo.lsp" -eval '"(joe 3)"' >> $(DESTDIR)$(prefix)/bin/gcl
	chmod a+x $(DESTDIR)$(prefix)/bin/gcl
	rm -f $(DESTDIR)$(prefix)/bin/gclm.bat
	if gcc --version | grep mingw >/dev/null 2>&1 ; then (echo '@SET cd='; \
	 echo '@SET promp$=%prompt%'; \
	 echo '@PROMPT SET cd$Q$P'; \
	 echo '@CALL>%temp%.\setdir.bat'; \
	 echo '@'; \
	 echo '% do not delete this line %'; \
	 echo '@ECHO off'; \
	 echo 'PROMPT %promp$%'; \
	 echo 'FOR %%c IN (CALL DEL) DO %%c %temp%.\setdir.bat'; \
	 echo 'set cwd=%cd%'; \
	 echo 'set libdir=%cd%\..\lib\gcl-$(VERSION)'; \
	 echo 'set unixportdir=%libdir%\unixport'; \
	 echo 'path %cd%\..\mingw\bin;%PATH%'; \
	 echo "start %unixportdir%\$(FLISP).exe -dir %unixportdir% -libdir %libdir% -eval \"(setq si::*allow-gzipped-file* t)\" %1 %2 %3 %4 %5 %6 %7 %8 %9" ) > $(DESTDIR)$(prefix)/bin/gclm.bat ; fi
	rm -f $(DESTDIR)$(prefix)/bin/gclfinal.bat
	if gcc --version | grep -i mingw >/dev/null 2>&1 ; then (echo 'ECHO path %1\mingw\bin;%PATH% > gcli.bat'; \
	 echo "ECHO start %1\lib\gcl-$(VERSION)\unixport\$(FLISP).exe -dir %1\lib\gcl-$(VERSION)\unixport -libdir %1\lib\gcl-$(VERSION) -eval \"(setq si::*allow-gzipped-file* t)\" %1 %2 %3 %4 %5 %6 %7 %8 %9 >> gcli.bat" ) > $(DESTDIR)$(prefix)/bin/gclfinal.bat ; fi

install: 
	$(MAKE) install1 "INSTALL_LIB_DIR=$(prefix)/lib/gcl-`cat majvers`.`cat minvers`" "prefix=$(prefix)" "DESTDIR=$(DESTDIR)"
INSTALL_LIB_DIR=
install1:
	mkdir -p $(DESTDIR)$(prefix)/lib 
	mkdir -p $(DESTDIR)$(prefix)/bin
	mkdir -p $(DESTDIR)$(prefix)/share
	cp -a man $(DESTDIR)$(prefix)/share/
	mkdir -p $(DESTDIR)$(INSTALL_LIB_DIR)
	MINSTALL_LIB_DIR=`echo $(INSTALL_LIB_DIR) | sed -e 'sX^\([a-z]\):X/\1Xg'` ; \
	$(MAKE) install-command "INSTALL_LIB_DIR=$(INSTALL_LIB_DIR)" "prefix=$(prefix)" "DESTDIR=$(DESTDIR)" "BINDIR=$$MINSTALL_LIB_DIR/unixport"
	rm -f $(DESTDIR)$(prefix)/bin/gcl.exe
	tar cf - $(PORTDIR)/$(FLISP)$(EXE) info/*.info* $(LISP_LIB) \
	$(TCL_EXES)  |  (cd $(DESTDIR)$(INSTALL_LIB_DIR) ;tar xf -)
	if gcc --version | grep -i mingw >/dev/null 2>&1 ; then if grep -i oncrpc makedefs >/dev/null 2>&1 ; then cp /mingw/bin/oncrpc.dll $(DESTDIR)$(INSTALL_LIB_DIR)/$(PORTDIR); fi ; fi
	cd $(DESTDIR)$(INSTALL_LIB_DIR)/$(PORTDIR) && \
		mv $(FLISP)$(EXE) temp$(EXE) && \
		echo '(reset-sys-paths "$(INSTALL_LIB_DIR)/")(si::save-system "$(FLISP)$(EXE)")' | ./temp$(EXE) && \
		rm -f temp$(EXE)
	if [ -e "unixport/rsym$(EXE)" ] ; then cp unixport/rsym$(EXE) $(DESTDIR)$(INSTALL_LIB_DIR)/unixport/ ; fi
#	ln $(SYMB) $(INSTALL_LIB_DIR)/$(PORTDIR)/$(FLISP)$(EXE) \
#	 $(DESTDIR)$(prefix)/bin/gcl.exe
	if [ -d "$(TK_CONFIG_PREFIX)" ] ; then  \
	cat gcl-tk/gcltksrv$(BAT) | \
	sed -e "s!GCL_TK_DIR=.*!GCL_TK_DIR=$(INSTALL_LIB_DIR)/gcl-tk!g"  \
	-e "s!TK_LIBRARY=.*!TK_LIBRARY=$(TK_LIBRARY)!g" > \
	$(DESTDIR)$(INSTALL_LIB_DIR)/gcl-tk/gcltksrv$(BAT) ; \
	chmod a+x $(DESTDIR)$(INSTALL_LIB_DIR)/gcl-tk/gcltksrv$(BAT) ; fi
#	if [ -d "$(TK_CONFIG_PREFIX)" ] ; then  \
#	(cd $(DESTDIR)$(INSTALL_LIB_DIR)/gcl-tk/demos ; \
#	echo '(load "../tkl.o")(TK::GET-AUTOLOADS (directory "*.lisp"))' | ../../$(PORTDIR)/$(FLISP)$(EXE)) ; fi
	if test "$(EMACS_SITE_LISP)" != "" ; then (cd elisp ; $(MAKE) install DESTDIR=$(DESTDIR)) ; fi
	if test "$(INFO_DIR)" != "unknown"; then (cd info ; $(MAKE) install DESTDIR=$(DESTDIR)) ; fi
	if test "$(INFO_DIR)" != "unknown"; then (cd xgcl-2 ; $(MAKE) install DESTDIR=$(DESTDIR)) ; fi
	if gcc --version | grep -i mingw >/dev/null 2>&1 ; then cp COPYING.LIB-2.0 readme-bin.mingw $(prefix) ; fi
	if gcc --version | grep -i mingw >/dev/null 2>&1 ; then cp gcl.ico $(prefix)/bin ; fi
	if gcc --version | grep -i mingw >/dev/null 2>&1 ; then rm -rf $(prefix)/install; mkdir $(prefix)/install ; cp windows/install.lsp $(prefix)/install ; windows/instdos.sh windows/sysdir.bat $(prefix)/bin/sysdir.bat ; fi
	-if gcc --version | grep -i mingw >/dev/null 2>&1 ; then rm -rf $(prefix)/doc; mkdir $(prefix)/doc; cp info/*.html $(prefix)/doc ; fi
	-if gcc --version | grep -i mingw >/dev/null 2>&1 ; then rm -rf $(prefix)/doc; mkdir $(prefix)/doc; cp -rp info/gcl info/gcl-si info/gcl-tk  $(prefix)/doc ; fi

gclclean:

	(cd $(BINDIR); $(MAKE) clean)
	(cd mp ; $(MAKE) clean)
	(cd $(ODIR); $(MAKE) clean)
	(cd $(LSPDIR); $(MAKE) clean)
	(cd $(CMPDIR); $(MAKE) clean)
	(cd $(PORTDIR); $(MAKE) clean)
	(cd gcl-tk ; $(MAKE) clean)
	cd $(CLCSDIR) && $(MAKE) clean
	cd $(PCLDIR) && $(MAKE) clean
	cd xgcl-2 && $(MAKE) clean
	(cd $(TESTDIR); $(MAKE) clean)
#	(cd info ; $(MAKE) clean)
#	find binutils -name "*.o" -exec rm {} \;
	rm -rf binutils
	rm -f foo.tcl config.log makedefs makedefsafter config.cache config.status makedefc
	rm -f h/config.h h/gclincl.h h/cmpinclude.h h/gmp.h
	rm -f xbin/gcl foo foo.c bin/gclm.bat gmp_all
	rm -f h/*-linux.defs h/bfd.h h/bfdlink.h h/ansidecl.h h/symcat.h
	rm -f windows/gcl.iss bin/gcl.bat windows/gcl.ansi.iss windows/install.ansi.lsp \
		windows/install.lsp windows/sysdir.bat
	rm -rf windows/Output
	rm -f ansi-tests/test_results ansi-tests/gazonk*lsp
	rm -rf autom4te.cache h/mcompdefs.h
	rm -f config.log config.cache config.status tmpx $(PORTDIR)/gmon.out gcl.script machine system

clean: gclclean
	-[ -z "$(GMPDIR)" ] || (cd $(GMPDIR) && $(MAKE) distclean)
	-[ -z "$(GMPDIR)" ] || rm -rf $(GMPDIR)/.deps $(GMPDIR)/libgmp.a
#	-cd binutils/intl && $(MAKE) distclean
#	-cd binutils/bfd && $(MAKE) distclean
#	-cd binutils/libiberty && $(MAKE) distclean

CMPINCLUDE_FILES=$(HDIR)cmpincl1.h $(HDIR)gclincl.h $(HDIR)compbas.h $(HDIR)type.h $(HDIR)mgmp.h \
	$(HDIR)lu.h $(HDIR)globals.h  $(HDIR)vs.h \
	$(HDIR)bds.h $(HDIR)frame.h \
	$(HDIR)lex.h \
	$(HDIR)compprotos.h  $(HDIR)immnum.h

OTHERS=$(HDIR)notcomp.h $(HDIR)rgbc.h $(HDIR)stacks.h 

$(HDIR)new_decl.h:
	(cd o && $(MAKE) ../$@)

$(HDIR)mcompdefs.h: $(HDIR)compdefs.h $(HDIR)new_decl.h
	$(AWK) 'BEGIN {print "#include \"include.h\"";print "#include \"cmponly.h\"";print "---"} {a=$$1;gsub("\\.\\.\\.","",a);print "\"#define " $$1 "\" " a}' $< |\
	$(CC) -E -I./$(HDIR) - |\
	$(AWK) '/^\-\-\-$$/ {i=1;next} {if (!i) next} {gsub("\"","");print}' >$@

$(HDIR)cmpinclude.h: $(HDIR)mcompdefs.h $(CMPINCLUDE_FILES) $(HDIR)config.h
	cp $< $(@F)
	cat $(CMPINCLUDE_FILES) | $(CC) -E -I./$(HDIR) - | $(AWK) '/^# |^$$|^#pragma/ {next}{print}' >> $(@F)
	./xbin/move-if-changed mv $(@F) $@
	./xbin/move-if-changed cp $@ o/$(@F)

go:
	mkdir go
	(cd go ; cp -s ../o/makefile ../o/*.o ../o/*.c ../o/*.d ../o/*.ini  .)
	(cd go ; $(MAKE)  go)

tar:
	rm -f gcl-`cat majvers`.`cat minvers`
	xbin/distribute ../ngcl-`cat majvers`.`cat minvers`-beta.tgz

configure: configure.in
	autoconf configure.in > configure
	chmod a+rx configure

kcp:
	(cd go ; $(MAKE)  "CFLAGS = -I../h -pg  -c -g ")
	(cd unixport ; $(MAKE) gcp)

.INTERMEDIATE: $(HDIR)mcompdefs.h
