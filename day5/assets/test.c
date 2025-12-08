#include "heap_sort.h"
#include "insertion_sort.h"
#include "quick_sort.h"
#include "selection_sort.h"
#include "sort_util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void check(void (*f)(int a[], int n), int const *data, int n,
           char const *name) {
  int *a = (int *)calloc(n, sizeof(int));
  memcpy(a, data, n * sizeof(n));

  printf("original:\n");
  display(a, n);

  f(a, n);

  printf("sorted:\n");
  display(a, n);

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

void test_sort(void (*f)(int a[], int n), int times) {
  for (int i = 0; i < times; i++) {
    check(f, rand_arr(20, 100), 20, "randome array");
  }
}

int main(void) {
  printf("test of selection_sort:\n");
  test_sort(selection_sort, 5);

  printf("test of insertion_sort:\n");
  test_sort(insertion_sort, 5);

  printf("test of heap_sort:\n");
  test_sort(heap_sort, 5);

  printf("test of quick_sort:\n");
  test_sort(quick_sort, 5);
}
