// Bit field can access and store directly, init as normal struct;
// Bit field should not exceed it's range
// Bit field should not cross uint32 border

#include <iostream>
#include <cstdlib>

using namespace std;

typedef struct BitField {
    uint16_t first:3;
    uint16_t second:13;
} BitField;

int main(int argc, char **argv) {
    BitField bf;
    bf.first = 3;
    bf.second = 0xbd;

    cout << "size should b 4: " << sizeof(bf) << endl;
    cout << "bf.first 3b: " << hex << bf.first << endl;
    cout << "bf.second 13b: " << hex << bf.second << endl;
}
