#include "heap_sort.h"
#include "quick_sort.h"
#include "sort_util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void check(void (*f)(int a[], int n), int const *data, int n,
           char const *name) {
  int *a = (int *)calloc(n, sizeof(int));
  memcpy(a, data, n * sizeof(n));

  f(a, n);

  if (!is_sorted(a, n)) {
    fprintf(stderr, "Error: %s\n", name);
    exit(EXIT_FAILURE);
  }

  free(a);
}

int *rand_arr(int len, int max) {
  int *a = (int *)calloc(len, sizeof(int));

  for (int i = 0; i < len; i++) {
    a[i] = rand() % max;
  }

  return a;
}

int *rand_reverse_sorted_arr(int len) {
  int *a = (int *)calloc(len, sizeof(int));

  a[len - 1] = 10;
  for (int i = len - 2; i >= 0; i--) {
    a[i] = a[i + 1] + rand() % 10 + 1;
  }

  return a;
}

void test_sort(void (*f)(int a[], int n), int times) {
  for (int i = 0; i < times; i++) {
    /* check(f, rand_arr(20, 100), 20, "randome array"); */
    check(f, rand_reverse_sorted_arr(20), 20, "randome array");
  }
}

int main(void) {
  test_sort(heap_sort, 10000);
  /* test_sort(quick_sort, 10000); */
}
