# make -f t.mk -e cflags=yy -e cxxflags=zz
install: dir= ls -l
curdir = ../make
absdir = $(shell readlink  -f $(curdir))

phony: install print
	
override cflags=xx
install:
	@echo "hello again" ${dir} ${cflags} ${cxxflags}

print:
	@echo $(curdir) "\t" $(absdir)
