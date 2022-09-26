#include <iostream> 
#include <memory> 

using namespace std;

class base {
public:
    base() = default;
    ~base() = default;

public:
    virtual void call1() = 0;
    void call2() {}
};

class derive1 : public base {

public:
    virtual void call1() {
        cout << "no override is also ok: " << endl; 
    }
};

class derive2 : public base {

public:
    virtual void call1() override {
        cout << "override a virutal function in derived: " << endl; 
    }

    void call2() override{
        cout << "override a normal function in derived: " << endl; 
    }
};

int main()
{
    derive1 d1;
    d1.call1();

    derive2 d2;
    d2.call1();
    d2.call2();

    
}
