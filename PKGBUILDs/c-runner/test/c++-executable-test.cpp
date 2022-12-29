#!/usr/bin/c-runner clang++ c++-test1.cpp

#include <iostream>

extern int foo;

int main() {
  int xyz=0;
  using namespace std;
  cout << "hello world" << endl;
  cout << foo << endl;
  xyz++;
  return 0;
}
