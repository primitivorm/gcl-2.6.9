# makefile for making pcl -- W. Schelter.

-include ../makedefs

FILES:=$(shell ls -1 gcl_*.lisp | sed 's,\.lisp,,1') gcl_pcl_impl_low

GFILES1:= 0 1 2 3 4 5 6 7
GFILES:=$(addprefix gcl_pcl_gazonk,$(GFILES1))

AFILES:=$(FILES) $(GFILES)

SETUP='(load "sys-package.lisp")' \
	'(setq *features* (delete (quote :kcl) *features*))'\
	'(load "defsys.lisp")(push (quote :kcl) *features*)' \
	'(setq pcl::*default-pathname-extensions* (cons "lisp" "o"))' \
	'(setq pcl::*pathname-extensions* (cons "lisp" "o"))' \
	'(load "sys-proclaim.lisp")' \
	'(setq compiler::*default-h-file* t)'\
	'(setq compiler::*default-c-file* t)'\
	'(setq compiler::*default-data-file* t)'\
	'(setq compiler::*default-system-p* t)' \
	'(setq compiler::*keep-gaz* t compiler::*tmp-dir* "")'

all: $(addsuffix .c,$(AFILES)) $(addsuffix .o,$(AFILES)) 

saved_gcl_pcl: ../unixport/saved_gcl$(EXE)
	cp ../h/cmpinclude.h .
	echo $(SETUP) '(pcl::compile-pcl)' | $< 
	echo $(SETUP) '(pcl::load-pcl)(si::save-system "$@")' | $<

$(addsuffix .c,$(AFILES)) $(addsuffix .data,$(AFILES))\
	$(addsuffix .h,$(AFILES)) $(addsuffix .lsp,$(GFILES)): \
	$(addsuffix .lisp,$(subst gcl_pcl_impl_low,impl/gcl/gcl_pcl_impl_low,$(FILES)))
	rm -f *.o *gazonk*
	cp ../h/cmpinclude.h .
	echo ${SETUP} '(pcl::compile-pcl)' | ../unixport/saved_gcl$(EXE)
	for i in gazonk* ; do \
		j=$$(echo $$i | sed 's,\..*$$,,1');k="gazonk$$(echo $$j | cut -f3 -d\_)";\
		l=$$(echo $$i | sed 's,^.*\.,,1');\
		if test "$$l" = "data" ; then\
			cp $$i gcl_pcl_$$k.$$l;\
		else\
			cat $$i | sed   -e "s,$$j\.h,gcl_pcl_$$k.h,1"\
				-e "s,init_.*$$j,init_gcl_pcl_$$k,g" >gcl_pcl_$$k.$$l && rm $$i;\
		fi; done

%.o: %.c %.h %.data
	$(CC) $(CFLAGS) -c $< -o $@
	../xbin/append $*.data $@

clean:
	rm -f *.o *.fn *.exe *.dll saved_gcl_pcl$(EXE) cmpinclude.h *.c *.h *.data *gazonk*


# remake the sys-package.lisp and sys-proclaim.lisp files
# Those files may be empty on a first build.
remake-sys-files:
	rm -f *.o *gazonk*
	cp ../h/cmpinclude.h .
	echo ${SETUP} '(load "../cmpnew/gcl_collectfn.lsp")(compiler::emit-fn t)' \
		'(pcl::compile-pcl)' | ../unixport/saved_gcl$(EXE) ../unixport/
	echo ${SETUP} '(load "../cmpnew/gcl_collectfn.lsp") '\
		'(pcl::load-pcl)(in-package "PCL")(renew-sys-files)' | \
		../unixport/saved_gcl$(EXE) ../unixport/
	cp sys-proclaim.lisp xxx
	cat xxx | sed -e "s/COMPILER::CMP-ANON//g" > sys-proclaim.lisp
	rm xxx


tar:
	$(MAKE) -f makefile.gcl  tar1 DIR=`pwd`

tar1:
	(cd .. ; tar cvf - `basename ${DIR}` | gzip -c > `basename ${DIR}`.tgz) 
