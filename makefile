HSFLAGS = -O -fwarn-name-shadowing -static #-dynamic
PROGS=jpd
OBJS=Xhtml.o

all:$(PROGS)

jpd:jpd.hs Xhtml.o

#ghc $(HSFLAGS) --make -o jpd jpd.hs $(OBJS)

Xhtml.o:Xhtml.hs

% : %.hs
	ghc $(HSFLAGS) --make -o $@ $<

install:
	install -m 755 -o apache -g apache $(PROGS) /var/www/cgi-bin
	ls -l /var/www/cgi-bin

clean:
	-rm *.hi *.o $(PROGS)
