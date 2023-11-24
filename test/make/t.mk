# make -f t.mk -e cflags=yy -e cxxflags=zz
install: dir= ls -l

override cflags=xx
install:
	@echo "hello again" ${dir} ${cflags} ${cxxflags}
