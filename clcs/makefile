-include ../makedefs

COMPILE_FILE=./saved_clcs_gcl$(EXE) ./ -system-p -c-file -data-file \
	-o-file nil -h-file -compile

FILES:=$(shell ls -1 gcl_clcs_*.lisp | sed 's,\.lisp,,1')

all: $(addsuffix .c,$(FILES)) $(addsuffix .o,$(FILES))

saved_clcs_gcl: ../unixport/saved_pcl_gcl$(EXE)
	echo '(load "package.lisp")(load "myload.lisp")(si::save-system "$@")' | $< $(<D)/

%.h %.data %.c : %.lisp saved_clcs_gcl
	cp ../h/cmpinclude.h .
	$(COMPILE_FILE) $<

%.o: %.c %.h %.data
	$(CC) $(CFLAGS) -c $< -o $@
	../xbin/append $*.data $@

%.fn: ../cmpnew/gcl_collectfn.o %.lisp ./saved_clcs_gcl$(EXE)
	echo '(load "$<")(compiler::emit-fn t)(compile-file "$*.lisp")' |./saved_clcs_gcl$(EXE)

sys-proclaim.lisp: $(addsuffix .fn,$(FILES))
	echo '(in-package "CONDITIONS")' \
	'(load "../cmpnew/gcl_collectfn")'\
	'(compiler::make-all-proclaims "*.fn")' | ../xbin/gcl

compile: ${LISP}
	echo '(load "package.lisp")(load "loading.lisp")(jamie-load-clcs :compile)' | ${LISP}

saved_full_gcl: ${LISP}
	echo '(load "package.lisp")(load "loading.lisp")(jamie-load-clcs :compiled)(system::save-system "saved_full_gcl")' | ${LISP}

clean:
	rm -f *.o *.fn saved_full_gcl$(EXE) saved_full_gcl cmpinclude.h *.c *.h *.data saved_clcs_gcl$(EXE)
#.INTERMEDIATE: saved_clcs_gcl
