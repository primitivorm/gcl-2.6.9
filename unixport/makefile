SPECIAL_RSYM = rsym.c

LIBC	= -lc

-include ../makedefs

RSYM=

HDIR	= ../h
ODIR	= ../o
MDIR	= ../mod
LSPDIR	= ../lsp
CMPDIR	= ../cmpnew
XDIR	= ../xgcl-2
CLCSDIR = ../clcs
PCLDIR  = ../pcl
PORTDIR = $(shell pwd)

LD_FLAGS:=$(LDFLAGS)
ifneq ($(FIRST_FILE),)
LD_FLAGS:=$(LD_FLAGS) $(ODIR)/$(FIRST_FILE)
endif
LD_LIBS_PRE:=$(addprefix -u ,$(PATCHED_SYMBOLS))
LD_LIBS_POST:=$(LIBS) $(LIBC) -lgclp
ifneq ($(LAST_FILE),)
LD_LIBS_POST:=$(LD_LIBS_POST) $(ODIR)/$(LAST_FILE)
endif

ifeq ($(ARRS),)
ARRS:=ar rs
endif

libgclp.a: $(ODIR)/gcllib.a
	cp $< $@
	ranlib $@

gmpfiles: $(shell [ -z "$(GMPDIR)" ] || find ../$(GMPDIR) -name "*.o" |grep -v '\.lib')
	rm -rf gmp
	mkdir gmp
	a="$^" ; \
	for i in $$a ; do \
		cp $$i gmp/$$(echo $$i | sed -e 's,\.\./,,1' -e 's,/,_,g') ; \
	done
	touch $@

bfdfiles: $(shell ! [ -d ../binutils ] || find ../binutils -name "*.o")
	rm -rf bfd
	mkdir bfd
	a="$^" ; \
	for i in $$a ; do \
		cp $$i bfd/$$(echo $$i | sed -e 's,\.\./,,1' -e 's,/,_,g') ; \
	done 
	touch $@

OOBJS:=$(shell j=$$(ar t $(ODIR)/gcllib.a) ; for i in $$(find $(ODIR) -name "*.o") ; do if ! echo $$j |grep $$(basename $$i) >/dev/null 2>&1 ; then echo $$i ; fi ; done)
OOBJS:=$(filter-out $(ODIR)/$(FIRST_FILE),$(OOBJS))
OOBJS:=$(filter-out $(ODIR)/$(LAST_FILE),$(OOBJS))
OOBJS:=$(filter-out $(ODIR)/plttest.o,$(OOBJS))
OBJS:=$(OOBJS) $(shell find $(LSPDIR) -name "*.o")
OBJS:=$(OBJS) $(shell find $(XDIR) -name "*.o")
OBJS:=$(OBJS) $(shell find $(CMPDIR) -name "*.o" | grep -v collectfn.o)

#MODOBJS:=$(shell find $(MDIR) -name "*.o")
PCLOBJS:=$(shell find $(PCLDIR) -name "*.o")
ANSIOBJS:=$(PCLOBJS) $(shell find $(CLCSDIR) -name "*.o")

$(LSPDIR)/auto_new.lsp: $(LSPDIR)/auto.lsp
	cp $< $@
	[ "$(RL_OBJS)" = "" ] || \
		echo "(AUTOLOAD 'init-readline '|readline|)" >>$@

init_gcl.lsp.tmp: init_gcl.lsp.in
	cp $< $@

init_pre_gcl.lsp.tmp: init_pre_gcl.lsp.in
	cp $< $@

init_mod_gcl.lsp.tmp: init_mod_gcl.lsp.in
	cp $< $@

init_xgcl.lsp.tmp: init_gcl.lsp.tmp
	ln -snf $< $@

init_pcl_gcl.lsp.tmp: init_pcl_gcl.lsp.in ../cmpnew/gcl_cmpmain.lsp \
		../pcl/sys-package.lisp ../clcs/package.lisp \
		$(shell find ../clcs/ -name "clcs_*.lisp")

	awk '/^ *@LI-PCL-PACKAGE@/{i=1;next} {if (i==0) print}' $< >$@
#	cat ../cmpnew/gcl_cmpmain.lsp >>$@
	cat ../pcl/sys-package.lisp >>$@
	awk '/^ *@LI-PCL-PACKAGE@/{i=1;next} {if (i==1) print}' $< >>$@

init_ansi_gcl.lsp.tmp: init_ansi_gcl.lsp.in ../cmpnew/gcl_cmpmain.lsp \
		../pcl/sys-package.lisp ../clcs/package.lisp

	awk '/^ *@LI-PCL-PACKAGE@/{i=1;next} \
		/^ *@LI-CLCS-PACKAGE@/{i=2;next} {if (i==0) print}' $< >$@
#	cat ../cmpnew/gcl_cmpmain.lsp >>$@
	cat ../pcl/sys-package.lisp >>$@
	awk '/^ *@LI-PCL-PACKAGE@/{i=1;next} \
		/^ *@LI-CLCS-PACKAGE@/{i=2;next} {if (i==1) print}' $< >>$@
	cat ../clcs/package.lisp >>$@
	awk '/^ *@LI-PCL-PACKAGE@/{i=1;next} \
		/^ *@LI-CLCS-PACKAGE@/{i=2;next} {if (i==2) print}' $< >>$@


init_%.lsp: init_%.lsp.tmp

	cat $< | sed \
		-e "s#@LI-VERS@#(`cat ../majvers`.`cat ../minvers`) `date`#1" \
		-e "s#@LI-EXTVERS@#`cat ../minvers | cut -f2 -d.`#1" \
		-e "s#@LI-MINVERS@#`cat ../minvers | cut -f1 -d.`#1" \
		-e "s#@LI-MAJVERS@#`cat ../majvers`#1" \
		-e "s#@LI-CC@#\"$(CC) -c $(FINAL_CFLAGS)\"#1" \
		-e "s#@LI-LD@#\"$(CC) $(LD_FLAGS) -o \"#1" \
		-e "s#@LI-LD-LIBS@#\" $(LD_LIBS_PRE) -l$* $(LD_LIBS_POST)\"#1" \
		-e "s#@LI-OPT-THREE@#\"$(O3FLAGS)\"#1" \
		-e "s#@LI-OPT-TWO@#\"$(O2FLAGS)\"#1" \
		-e "s#@LI-INIT-LSP@#\"$@\"#1" >$@

saved_%:raw_% $(RSYM) init_%.lsp raw_%_map msys \
		$(CMPDIR)/gcl_cmpmain.lsp \
		$(CMPDIR)/gcl_lfun_list.lsp \
		$(CMPDIR)/gcl_cmpopt.lsp $(HDIR)/cmpinclude.h \
		$(LSPDIR)/gcl_auto_new.lsp

	cp init_$*.lsp foo
	echo " (in-package \"USER\")(system:save-system \"$@\")" >>foo
	ar x lib$*.a $$(ar t lib$*.a |grep ^gcl_)
	$(PORTDIR)/raw_$*$(EXE) $(PORTDIR)/ -libdir $(GCLDIR)/ < foo
#       check that saved image can be prelinked
	[ "$(PRELINK_CHECK)" = "" ] || \
		! [ -x /usr/bin/objdump ] || \
		! /usr/bin/objdump -f $@ | grep "file format" | grep "elf" || \
		! /usr/bin/objdump -R $@ |grep R_.*_COPY || \
		! echo "$@ cannot be prelinked"

$(RSYM): $(SPECIAL_RSYM) $(HDIR)/mdefs.h
	$(CC) $(LD_FLAGS) $(CFLAGS) -I$(HDIR) -I$(ODIR) -o $(RSYM) $(SPECIAL_RSYM)

msys: msys.c
	PATH=/usr/bin:$$PATH gcc $< -o $@ # Unix binary if running wine

$(HDIR)/mdefs.h: $(HDIR)/include.h
	cat $(HDIR)/include.h | sed -e "/include/d" > $(HDIR)/mdefs.h

libgcl.a: $(OBJS) sys_gcl.o gmpfiles bfdfiles # plt_gcl.o
	rm -rf $@
	$(ARRS) $@ $(filter %.o,$^) $(shell find gmp bfd -name "*.o")

libpre_gcl.a: $(OOBJS) sys_pre_gcl.o gmpfiles bfdfiles # plt_pre_gcl.o
	rm -rf $@
	$(ARRS) $@ $(filter %.o,$^) $(shell find gmp bfd -name "*.o")

#libmod_gcl.a: $(OBJS) $(MODOBJS) sys_mod_gcl.o gmpfiles bfdfiles # plt_mod_gcl.o
#	rm -rf $@
#	$(ARRS) $@ $(filter %.o,$^) $(shell find gmp bfd -name "*.o")

libxgcl.a: libgcl.a
	ln -snf $< $@

libansi_gcl.a: $(OBJS) $(ANSIOBJS) sys_ansi_gcl.o gmpfiles bfdfiles # plt_ansi_gcl.o
	rm -rf $@
	$(ARRS) $@ $(filter %.o,$^) $(shell find gmp bfd -name "*.o")

libpcl_gcl.a: $(OBJS) $(PCLOBJS) sys_pcl_gcl.o gmpfiles bfdfiles # plt_pcl_gcl.o
	rm -rf $@
	$(ARRS) $@ $(filter %.o,$^) $(shell find gmp bfd -name "*.o")

raw_%_map raw_%: lib%.a libgclp.a $(SYSTEM_OBJS) #$(EXTRAS)
	touch raw_$*_map
ifeq ($(GNU_LD),1)
	$(CC) $(LD_FLAGS) -o raw_$*$(EXE) $(filter %.o,$^) -L. $(EXTRA_LD_LIBS) -Wl,-Map raw_$*_map $(LD_LIBS_PRE) -l$* $(LD_LIBS_POST)
else
	$(CC) $(LD_FLAGS) -o raw_$*$(EXE) $(filter %.o,$^) -L. $(EXTRA_LD_LIBS) $(LD_LIBS_PRE) -l$* $(LD_LIBS_POST)
endif
#	diff map_$* map_$*.old >/dev/null || (cp map_$* map_$*.old && rm -f $@ && $(MAKE) $@)
#	cp map_$*.old map_$*

map_%:
	touch $@

#plt_%.h: map_%
#	cat $< | awk '/^ .plt/ {if (NF==4) i=1;next;} \
#		{if (!NF) i=0; if (!i) next; } \
#		{b=$$2; sub("@.*$$","",b);print "{\"" b "\"," $$1 "}"}' | \
#		sort | awk '{A[++k]=$$0} END {for (i=1;i<=k;i++) \
			printf("%s%s\n",A[i],i==k ? "" : ",")}' >$@

#plt_%.o: plt_%.h plt.c
#	ln -snf $< plt.h
#	$(CC) $(LD_FLAGS) -c -o $@ plt.c $(CFLAGS) -I$(HDIR) -I$(ODIR)

clean:
	rm -rf  saved_*$(EXE) raw_*$(EXE) *.o core a.out $(RSYM) \
		$(LSPDIR)/auto_new.lsp foo *maxima* init_*.lsp lib*.a gmp* bfd* *.lsp.tmp \
		gazonk*.lsp plt*h *_map saved_* lib* raw_* msys out* log* tmp* gcl.script

.INTERMEDIATE: init_ansi_gcl.lsp.tmp init_gcl.lsp.tmp raw_gcl raw_ansi_gcl
.PRECIOUS: init_pre_gcl.lsp init_gcl.lsp init_ansi_gcl.lsp
