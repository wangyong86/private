1: shadown.cc
Functions has only diffent return value types can be overrided. Const function
must be called by const object. Const object pointer reference is also okay.

2: lambda.cc
lambda extend scope and lifecycle of variable, using functor like:

class B {
	operator(){
		....
	}

private:
	copyed vars; // important
};

it's size equal to data it copyed.
shard_ptr/pointer can be used to avoid copy.

3: functor.cc
std::bind is grammar sugar for functor
