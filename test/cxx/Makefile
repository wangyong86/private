TARGETS += a.out array basic destor fileop mmap shadow snprintf_test struct template template_a.o template.o testfile tsc heap
TARGETS += macro externc linecross ctor desinatorlist nestvec

CXX=g++
CPPFLAG+= -std=c++20

OBJS+=concept

all: $(OBJS)

clean:
	rm -f $(TARGETS)

concept: concept.cc
	$(CXX) $(CPPFLAG) $< -o $@
