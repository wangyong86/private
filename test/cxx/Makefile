OBJS += array basic destor fileop mmap shadow snprintf_test struct tsc heap
OBJS += cast define dump setw zigzag format zigzag enable_if enable_if_class
OBJS += macro externc linecross ctor desinatorlist nestvec builtin bitfield
OBJS += numeric static_inherit

CXX=g++
CPPFLAG+= -std=c++20

OBJS+=concept

all: $(OBJS)

clean:
	rm -f $(OBJS)

concept: concept.cc
	$(CXX) $(CPPFLAG) $< -o $@
