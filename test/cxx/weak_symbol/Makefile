flag	:= -g -O0
dflag	:= --shared
GCC		:= g++

TARGET	:= weak_symbol
LIBS	+= test.o inner.o

$(TARGET):  $(LIBS)
	$(GCC) $(flag) -o $@ $^

%.so: %.cpp
	$(GCC) $(dflag) -o $@ $<

%.o:%.cpp
	$(GCC) $(flag) -o $@ -c $<

clean:
	-@rm -f $(LIBS) $(TARGET)
