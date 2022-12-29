#! /usr/bin/c-runner gcc c-test1.c c-test2.c

#include <stdio.h>

extern int add (int,int);

int main() {
  int xyz=0;
  printf ("hello world\n");
  printf ("%d\n", add(xyz, 5));
  return 0;
}
