#include <iostream> 
#include <memory> 

using namespace std;

int main()
{
    std::shared_ptr<int> p;
    cout << "newly created :" << p << " concrete pointer: " << p.get() << endl;

    p= std::make_shared<int>();
    cout << "assigned pointer :" << p << " concrete pointer: " << p.get() << endl;
}
