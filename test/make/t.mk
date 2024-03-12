#install: dir= ls -l

install: wy.out

install: a.out
	@echo "hello again" ${flag}
	make -f t.mk e

e:a.out
	cp $< $@
