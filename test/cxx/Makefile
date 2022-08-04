OBJS += array basic destor fileop mmap shadow snprintf_test struct tsc heap
OBJS += macro externc linecross ctor desinatorlist nestvec

CXX=g++
CPPFLAG+= -std=c++20

OBJS+=concept

all: $(OBJS)

clean:
	rm -f $(OBJS)

concept: concept.cc
	$(CXX) $(CPPFLAG) $< -o $@
