/*
 * std heap behavior
 * front is first element
 * make_heap means data has sorted
 * pop_heap means top ele has been remove to the last pos, sorted first.
 * need pop_back to remove it.
 * push_heap means fill element
 */
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;
 
int main () {
  int myints[] = {10,20,30,5,15};
  vector<int> v(myints,myints+5);
  vector<int>::iterator it;
 
  make_heap (v.begin(),v.end());
  cout << "initial max heap   : ";
  for (unsigned i=0; i<v.size(); i++) cout << " " << v[i];
  cout << endl;
 
  pop_heap (v.begin(),v.end()); 
  cout << "max heap after pop : " ;
  for (unsigned i=0; i<v.size(); i++) cout << " " << v[i];
  cout << endl;

  v.pop_back();
  cout << "max heap after remove : " ;
  for (unsigned i=0; i<v.size(); i++) cout << " " << v[i];
  cout << endl;

  v.push_back(99); push_heap (v.begin(),v.end());
  cout << "max heap after push large ele: ";
  for (unsigned i=0; i<v.size(); i++) cout << " " << v[i];
  cout << endl;
 
  sort_heap (v.begin(),v.end());
  cout << "max heap after sort: ";
  for (unsigned i=0; i<v.size(); i++) cout << " " << v[i];
  cout << endl;
 
 
  return 0;
}

