flag	:= -g -O0
dflag	:= --shared
GCC		:= g++

TARGET	:= tdso
LIBS	+= test.o inner.so testdso.so

$(TARGET):  $(LIBS)
	$(GCC) $(flag) -o $@ $^

%.so: %.cpp
	$(GCC) $(dflag) -o $@ $<

%.o:%.cpp
	$(GCC) $(flag) -o $@ -c $<

clean:
	-@rm -f $(LIBS) $(TARGET)
