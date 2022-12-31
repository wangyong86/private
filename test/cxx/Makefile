OBJS += array basic destor fileop mmap shadow snprintf_test struct tsc heap
OBJS += define setw zigzag format zigzag enable_if enable_if_class
OBJS += macro externc linecross ctor desinatorlist nestvec builtin bitfield
OBJS += numeric static_inherit init

CXX=g++
CPPFLAG+= -std=c++20 -g -O0

OBJS+=concept

all: $(OBJS)

clean:
	rm -f $(OBJS)

concept: concept.cc
	$(CXX) $(CPPFLAG) $< -o $@
