#include "heap_sort.h"

#define CEIL_DIV(x, y) (((x) % (y) == 0) ? ((x) / (y)) : ((x) / (y) + 1))

void sift_down(int a[], int i, int n) {
  int p = i;
  while (p * 2 + 1 < n) {
    int snode = -1;
    int svalue = 0;

    if (p * 2 + 1 == n - 1) {
      snode = p * 2 + 1;
      svalue = a[p * 2 + 1];
    } else {
      if (a[p * 2 + 1] > a[p * 2 + 2]) {
        snode = p * 2 + 1;
        svalue = a[p * 2 + 1];
      } else {
        snode = p * 2 + 2;
        svalue = a[p * 2 + 2];
      }
    }

    if (a[p] < svalue) {
      a[snode] = a[p];
      a[p] = svalue;
      p = snode;
    } else {
      break;
    }
  }
}

void build_heap(int a[], int n) {
  for (int x = CEIL_DIV(n, 2) - 1; x >= 0; x--) {
    sift_down(a, x, n);
  }
}

void heap_sort(int a[], int n) {
  build_heap(a, n);

  for (int m = n - 1; m > 0; m--) {
    int tmp = a[0];
    a[0] = a[m];
    a[m] = tmp;

    sift_down(a, 0, m);
  }
}
