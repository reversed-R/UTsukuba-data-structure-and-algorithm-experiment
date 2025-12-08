#include "quick_sort.h"

void swap(int *x, int *y) {
  int tmp = *x;
  *x = *y;
  *y = tmp;
}

int partition(int a[], int pivot, int left, int right) {
  /* int tmp = a[pivot]; */
  /* a[pivot] = a[right]; */
  /* a[right] = tmp; */
  swap(a + pivot, a + right);

  int l = left;
  int r = right - 1;

  while (1) {
    while (a[l] < a[right]) {
      l++;
    }
    while (l <= r && a[r] >= a[right]) {
      r--;
    }

    if (l < r) {
      swap(a + l, a + r);
      /* int tmp = a[l]; */
      /* a[l] = a[r]; */
      /* a[r] = tmp; */
    } else {
      break;
    }
  }

  swap(a + l, a + right);

  return l;
}

void quick_sort_sub(int a[], int left, int right) {
  if (left < right) {
    int pivot = right;
    int p = partition(a, pivot, left, right);

    quick_sort_sub(a, left, p - 1);
    quick_sort_sub(a, p + 1, right);
  }
}

void quick_sort(int a[], int n) { quick_sort_sub(a, 0, n - 1); }
