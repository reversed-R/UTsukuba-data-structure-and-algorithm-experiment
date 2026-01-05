#include "common.h"
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int d[N][N]; // d[i][j]は、iからjへの最短距離
int p[N][N]; // p[i][j] = k; のとき、kは、iからjへの最短経路(i -> ... ->
             // j)のラストホップ(k -> j)のk
int stack[N];
int stack_p = -1;

int add_without_overflow(int x, int y) {
  if (x == INT_MAX || y == INT_MAX) {
    return INT_MAX;
  } else {
    return x + y;
  }
}

/**
 * Floydのアルゴリズムで，全ての頂点間の最短経路と重みを計算．
 * @return なし
 */
void floyd() {
  // 配列の初期化
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      d[i][j] = w[i][j];
      p[i][j] = i;
    }
  }

  for (int k = 0; k < N; k++) {     // 経由ノード
    for (int i = 0; i < N; i++) {   // 開始ノード
      for (int j = 0; j < N; j++) { // 終了ノード
        // M (= INT_MAX)に加算するとオーバーフローして負になってしまうのを回避
        int can = add_without_overflow(d[i][k], d[k][j]);
        if (can < d[i][j]) {
          d[i][j] = can;
          p[i][j] = p[k][j];
        }
      }
    }
  }
}

void stack_push(int stack[N], int *top, int v) {
  (*top)++;

  if (*top < N) {
    stack[*top] = v;
  } else {
    fprintf(stderr, "stack overflowed\n");
    exit(-1);
  }
}

int stack_pop(int stack[N], int *top) {
  if (*top >= 0) {
    return stack[(*top)--];
  } else {
    fprintf(stderr, "stack underflowed\n");
    exit(-1);
  }
}

bool stack_empty(int stack[N], int *top) { return *top >= 0; }

/**
 * 頂点mからnまでの最短路を出力．
 * @param m 始点
 * @param n 終点
 * @return なし
 */
void shortest_path(int m, int n) {
  if (d[m][n] == M) {
    printf("From %d to %d (w = M): unreachable\n", m, n);
  } else {
    int x = n;
    stack_push(stack, &stack_p, x);
    while (x != m) {
      x = p[m][x];
      stack_push(stack, &stack_p, x);
    }

    printf("From %d to %d (w = %d):", m, n, d[m][n]);
    while (stack_empty(stack, &stack_p)) {
      printf(" %d", stack_pop(stack, &stack_p));
    }
    printf("\n");
  }
}

/**
 * 任意の頂点間の最短路及び重さを表示．
 * @return 終了ステータス　0
 *
 */
void display() {
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      // 必要な処理を補う
      shortest_path(i, j);
    }
  }
}

/**
 * メイン関数．
 * @return 終了ステータス 0
 */
int main() {
  floyd();
  display();
  return 0;
}
