#include <iostream>
#include <cstdlib>

using namespace std;

int main(int argc, char **argv) {
	float f;
    *(int32_t*)&f = -1;
    cout << "float value for binary -1 is: " << hex << f << endl;
    int32_t i = (int32_t) (f *1000000); 
    cout << "convert int(float(int(-1)) * 10000) is : " << hex << i << endl;
    float j = float(i) / 100000.0;
    cout << "convert float(int(float(int(-1))) * 1000000)/1000000 is : " << hex << *(int32_t *)&j << endl;
}
