#include <iostream>
#include <type_traits>

template <int type, typename enable = void>
struct my_traits {
};

template <int type>
struct my_traits<type, std::enable_if_t<type == 0>> {
    static constexpr auto value = 0;
    void output() { std::cout << "hello" << std::endl;}
};

template <int type>
struct my_traits<type, std::enable_if_t<type != 0>> {
    static constexpr auto value = 1;
    void output() { std::cout << "world" << std::endl;}
};

int main(void)
{
    my_traits<10> a;
    a.output();

//    auto value = my_traits<0>::value;
//    std::printf("value: %d\n", value);

    return 0;
}
