#include "insertion_sort.h"

void insertion_sort(int a[], int n) {
  for (int i = 1; i < n; i++) {
    int ins = a[i];
    int j = i - 1;
    while (j >= 0 && ins < a[j]) {
      a[j + 1] = a[j];
      j--;
    }

    a[j + 1] = ins;
  }
}
