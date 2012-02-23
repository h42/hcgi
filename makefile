HSFLAGS = -O -fwarn-name-shadowing -static #-dynamic
PROGS=jpd
all:$(PROGS)

% : %.hs
	ghc $(HSFLAGS) --make -o $@ $<

install:
	install -m 755 -o apache -g apache $(PROGS) /var/www/cgi-bin
	ls -l /var/www/cgi-bin

clean:
	-rm *.hi *.o $(PROGS)
