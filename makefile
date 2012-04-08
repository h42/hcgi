HSFLAGS = -O -fwarn-name-shadowing -static  #-dynamic
OBJS=Html_base.o Html.o Html_def.o

PROGS=genx jpd css form   # monad color

.PHONY: ALL

ALL:$(PROGS)

monad:monad.hs

color:jpd

form:jpd

css:jpd

jpd:jpd.hs $(OBJS)
	ghc $(HSFLAGS) --make -o jpd jpd.hs


Html_base.o:Html_base.hs
	ghc $(HSFLAGS)  -c Html_base.hs  -o Html_base.o

Html_def.o:Html_def.hs Html_base.o Html.o
	ghc $(HSFLAGS)  -c Html_def.hs  -o Html_def.o

genx:genx.hs
	ghc $(HSFLAGS) --make -o genx genx.hs

Html.o:Html.hs
	ghc $(HSFLAGS) -c Html.hs -o Html.o

Html.hs:genx
	genx > Html.hs

% : %.hs
	ghc $(HSFLAGS) --make -o $@ $<

install:$(ALL)
	install -m 755 -o apache -g apache $(PROGS) /var/www/cgi-bin
	#install -m 755 -o apache -g apache plumber.jpg  /var/www/html
	#install -m 755 -o apache -g apache ALG_3rd.pdf  /var/www/html
	ls -l /var/www/cgi-bin

clean:
	-rm -v *.hi *.o $(PROGS) Html.hs
