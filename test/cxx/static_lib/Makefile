TARGET	:=mytest
LIBNAME	:=libxx_static.a
OBJS	:=libmodulea.o libmoduleb.o test.o
CFLAGS	:= -g3 -O0

$(TARGET): test.o $(LIBNAME)
	gcc -o $@ $^

$(LIBNAME): $(OBJS)
	ar rcs $@ $^

clean:
	make -s clean_i 2>/dev/null

clean_i:
	@-rm $(TARGET) $(LIBNAME) $(OBJS)
