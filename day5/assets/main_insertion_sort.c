#include "insertion_sort.h"
#include "sort_util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int const DATA_1[] = {3, 6, 8, 0, 5, 9, 7, 1, 2, 4};
static int const DATA_2[] = {4, 6, 9, 5, 3, 0, 2, 8, 7, 1};
static int const DATA_3[] = {6, 9, 5, 8, 7, 2, 0, 3, 1, 4};
static int const DATA_4[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int const DATA_5[] = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0};

void check(int const *data, int n, char const *name) {
  int *a = (int *)calloc(n, sizeof(int));
  memcpy(a, data, n * sizeof(n));

  display(a, n);
  insertion_sort(a, n);
  display(a, n);

  if (!is_sorted(a, n)) {
    fprintf(stderr, "Error: %s\n", name);
    exit(EXIT_FAILURE);
  }

  free(a);
}

int main(void) {
  check(DATA_1, 10, "DATA_1");
  check(DATA_2, 10, "DATA_2");
  check(DATA_3, 10, "DATA_3");
  check(DATA_4, 10, "DATA_4");
  check(DATA_5, 10, "DATA_5");
}
