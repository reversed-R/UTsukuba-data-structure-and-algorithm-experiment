#include <stdbool.h>
#include <stdio.h>

bool is_sorted(int a[], int n) {
  for (int i = 1; i < n; i++) {
    if (a[i] < a[i - 1]) {
      return false;
    }
  }

  return true;
}

void display(int a[], int n) {
  for (int i = 0; i < n; i++) {
    printf("%d ", a[i]);
  }

  printf("\n");
}
