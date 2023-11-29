flag	:= -g -O0
dflag	:= --shared
GCC		:= g++

LIBS	+= test.o inner.so testdso.so

tdso:  $(LIBS)
	$(GCC) $(flag) -o $@ $^

%.so: %.cpp
	$(GCC) $(dflag) -o $@ $<

%.o:%.cpp
	$(GCC) $(flag) -o $@ -c $<

clean:
	rm *.o *.so
