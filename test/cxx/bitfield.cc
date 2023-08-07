// Bit field:
// 1) can access and store directly, init as normal struct
// 2) should not exceed it's range
// 3) should not cross uint32 border
// 4) can be specify default value from c++17

#include <iostream>
#include <cstdlib>

using namespace std;

typedef struct BitField {
    uint16_t first:3 {0};
    uint16_t second:13 {0};
} BitField;

typedef struct DefaultMember {
    uint16_t first {0};
    uint16_t second {0};
} DefaultMember;

int main(int argc, char **argv) {
    BitField bf;
    bf.first = 3;
    bf.second = 0xbd;

    cout << "size should b 4: " << sizeof(bf) << endl;
    cout << "bf.first 3b: " << hex << bf.first << endl;
    cout << "bf.second 13b: " << hex << bf.second << endl;
}
