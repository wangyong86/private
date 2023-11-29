extern "C" {
__attribute__((weak)) int add_local(int a, int b)
//int add_local(int a, int b)
{
	return a * b;
}
}
