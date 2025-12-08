#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第5回",
  subtitle: "整列",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "2024 年 12 月 8 日",
)

== 基本課題

=== すべてのソートについての検証

以下のコードにより配列を乱数生成してテストした。
`srand()`を呼んでいないので、再現性があるはずである。

#sourcecode[```c
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
```]

その結果として以下が得られ、正常に動いていることが検証できた。

これにより各ソートにおける以下の指示

+ 入力したデータが正しく整列されることを 5個以上のデータ を用いて確認すること．
  + 長さ10を超えるデータで確認すること．
  + 5個以上のデータは，それぞれ内容および長さが異なるものにすること．
  + ヒント：乱数を用いて様々なデータについて整列動作を確認しても良い

の検証が正しく行われた。


#sourcecode[```c
$ ./test
test of selection_sort:
original:
83 86 77 15 93 35 86 92 49 21 62 27 90 59 63 26 40 26 72 36
sorted:
15 21 26 26 27 35 36 40 49 59 62 63 72 77 83 86 86 90 92 93
original:
11 68 67 29 82 30 62 23 67 35 29 2 22 58 69 67 93 56 11 42
sorted:
2 11 11 22 23 29 29 30 35 42 56 58 62 67 67 67 68 69 82 93
original:
29 73 21 19 84 37 98 24 15 70 13 26 91 80 56 73 62 70 96 81
sorted:
13 15 19 21 24 26 29 37 56 62 70 70 73 73 80 81 84 91 96 98
original:
5 25 84 27 36 5 46 29 13 57 24 95 82 45 14 67 34 64 43 50
sorted:
5 5 13 14 24 25 27 29 34 36 43 45 46 50 57 64 67 82 84 95
original:
87 8 76 78 88 84 3 51 54 99 32 60 76 68 39 12 26 86 94 39
sorted:
3 8 12 26 32 39 39 51 54 60 68 76 76 78 84 86 87 88 94 99
test of insertion_sort:
original:
95 70 34 78 67 1 97 2 17 92 52 56 1 80 86 41 65 89 44 19
sorted:
1 1 2 17 19 34 41 44 52 56 65 67 70 78 80 86 89 92 95 97
original:
40 29 31 17 97 71 81 75 9 27 67 56 97 53 86 65 6 83 19 24
sorted:
6 9 17 19 24 27 29 31 40 53 56 65 67 71 75 81 83 86 97 97
original:
28 71 32 29 3 19 70 68 8 15 40 49 96 23 18 45 46 51 21 55
sorted:
3 8 15 18 19 21 23 28 29 32 40 45 46 49 51 55 68 70 71 96
original:
79 88 64 28 41 50 93 0 34 64 24 14 87 56 43 91 27 65 59 36
sorted:
0 14 24 27 28 34 36 41 43 50 56 59 64 64 65 79 87 88 91 93
original:
32 51 37 28 75 7 74 21 58 95 29 37 35 93 18 28 43 11 28 29
sorted:
7 11 18 21 28 28 28 29 29 32 35 37 37 43 51 58 74 75 93 95
test of heap_sort:
original:
76 4 43 63 13 38 6 40 4 18 28 88 69 17 17 96 24 43 70 83
sorted:
4 4 6 13 17 17 18 24 28 38 40 43 43 63 69 70 76 83 88 96
original:
90 99 72 25 44 90 5 39 54 86 69 82 42 64 97 7 55 4 48 11
sorted:
4 5 7 11 25 39 42 44 48 54 55 64 69 72 82 86 90 90 97 99
original:
22 28 99 43 46 68 40 22 11 10 5 1 61 30 78 5 20 36 44 26
sorted:
1 5 5 10 11 20 22 22 26 28 30 36 40 43 44 46 61 68 78 99
original:
22 65 8 16 82 58 24 37 62 24 0 36 52 99 79 50 68 71 73 31
sorted:
0 8 16 22 24 24 31 36 37 50 52 58 62 65 68 71 73 79 82 99
original:
81 30 33 94 60 63 99 81 99 96 59 73 13 68 90 95 26 66 84 40
sorted:
13 26 30 33 40 59 60 63 66 68 73 81 81 84 90 94 95 96 99 99
test of quick_sort:
original:
90 84 76 42 36 7 45 56 79 18 87 12 48 72 59 9 36 10 42 87
sorted:
7 9 10 12 18 36 36 42 42 45 48 56 59 72 76 79 84 87 87 90
original:
6 1 13 72 21 55 19 99 21 4 39 11 40 67 5 28 27 50 84 58
sorted:
1 4 5 6 11 13 19 21 21 27 28 39 40 50 55 58 67 72 84 99
original:
20 24 22 69 96 81 30 84 92 72 72 50 25 85 22 99 40 42 98 13
sorted:
13 20 22 22 24 25 30 40 42 50 69 72 72 81 84 85 92 96 98 99
original:
98 90 24 90 9 81 19 36 32 55 94 4 79 69 73 76 50 55 60 42
sorted:
4 9 19 24 32 36 42 50 55 55 60 69 73 76 79 81 90 90 94 98
original:
79 84 93 5 21 67 4 13 61 54 26 59 44 2 2 6 84 21 42 68
sorted:
2 2 4 5 6 13 21 21 26 42 44 54 59 61 67 68 79 84 84 93
```]


=== 選択ソート

教科書 @textbook リスト5.2を参考にCでバインディングした実装が以下である。

#sourcecode[```c
void selection_sort(int a[], int n) {
  for (int i = 0; i < n; i++) {
    int min = i;
    for (int j = i + 1; j < n; j++) {
      if (a[j] < a[min]) {
        min = j;
      }
    }

    int tmp = a[i];
    a[i] = a[min];
    a[min] = tmp;
  }
}
```]

=== 挿入ソート

教科書 @textbook リスト5.5を参考にCでバインディングした実装が以下である。

#sourcecode[```c
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
```]

=== ヒープソート

教科書 @textbook リスト5.7 ~ 5.8を参考にCでバインディングした実装が以下である。

`build_heap()`及び`heap_sort()`は教科書のとおりであるため説明するまでもないが、
`sift_down()`は説明すると、
教科書 リスト4.1 ヒープにおける最小値の削除 を参考にしつつも、
ヒープの親子の大小関係を逆にしているため比較が逆になっていることに注意が必要である。

#sourcecode[```c
#define CEIL_DIV(x, y) (((x) % (y) == 0) ? ((x) / (y)) : ((x) / (y) + 1))

void sift_down(int a[], int i, int n) {
  int p = i;

  // ある節から葉に向かって大小の交換が起こる。
  // 子がある、すなわちヒープの大きさの半分過ぎまで、交換していく必要があるため、この比較が必要。
  while (p * 2 + 1 < n) {
    int snode = -1;
    int svalue = 0;

    // 教科書同様、節のインデックスから子が1つのみのときはちょうど次の値の時
    if (p * 2 + 1 == n - 1) {
      snode = p * 2 + 1;
      svalue = a[p * 2 + 1];
    } else {
      // 比較が教科書とは逆
      // 大きい方の子を選び、それと現在の節を比較したい
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
```]

=== クイックソート

教科書 @textbook リスト5.9 ~ 5.10を参考にCでバインディングした実装が以下である。

実装方法もピボット`right`との比較を繰り返し、最後に`l`と入れ替えるという教科書と同じ実装であり、特に説明するほどのこともないが、

`quick_sort()`の初回の`left`, `right`は自明に0と最後のインデックスなので`quick_sort_sub()`に分割して以下のような呼び出しがなされている。

#sourcecode[```c
#include "quick_sort.h"

void swap(int *x, int *y) {
  int tmp = *x;
  *x = *y;
  *y = tmp;
}

int partition(int a[], int pivot, int left, int right) {
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
```]

=== ヒープソートとクイックソートの性能比較

#sourcecode[```c
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

void test_sort(void (*f)(int a[], int n), int times) {
  for (int i = 0; i < times; i++) {
    check(f, rand_arr(20, 100), 20, "randome array");
  }
}

int main(void) {
  /* test_sort(heap_sort, 10000); */
  test_sort(quick_sort, 10000);
}
```]

上のように`heap_sort()`または`quick_sort()`を使って長さ20の配列を10000回をそれぞれソートした場合の実行時間を計測した(誤差を考慮してそれぞれ5回計測した。)。

ヒープソートの時、
#sourcecode[```bash
$ time ./performance_test
./performance_test  0.31s user 1.81s system 99% cpu 2.126 total
./performance_test  0.17s user 0.94s system 99% cpu 1.123 total
./performance_test  0.44s user 2.36s system 99% cpu 2.818 total
./performance_test  0.39s user 2.47s system 99% cpu 2.874 total
./performance_test  0.41s user 2.48s system 99% cpu 2.914 total
```]

クイックソートの時、
#sourcecode[```bash
$ time ./performance_test
./performance_test  0.17s user 0.94s system 99% cpu 1.111 total
./performance_test  0.20s user 0.92s system 99% cpu 1.127 total
./performance_test  0.18s user 0.99s system 99% cpu 1.176 total
./performance_test  0.16s user 0.93s system 99% cpu 1.103 total
./performance_test  0.18s user 0.91s system 98% cpu 1.109 total
```]


また、ソースコードの比較部分に`printf("compare\n")`を差し込んで、以下のコマンドで比較回数を確認した。

ヒープソートの時、
#sourcecode[```bash
$ ./performance_test | wc -l
2392331
```]

クイックソートの時、
#sourcecode[```bash
$ ./performance_test | wc -l
939074
```]


また、先程の`rand_arr()`を以下のような関数に取り替えて、
クイックソートの計算量が最悪になる、つまり、逆順にソートされている配列でソートをした。
#sourcecode[```c
int *rand_reverse_sorted_arr(int len) {
  int *a = (int *)calloc(len, sizeof(int));

  a[len - 1] = 10;
  for (int i = len - 2; i >= 0; i--) {
    a[i] = a[i + 1] + rand() % 10 + 1;
  }

  return a;
}
```]

このときかかる時間は、
#sourcecode[```bash
$ time ./performance_test
./performance_test  0.36s user 2.07s system 99% cpu 2.440 total
./performance_test  0.35s user 2.09s system 99% cpu 2.455 total
./performance_test  0.37s user 2.12s system 99% cpu 2.500 total
./performance_test  0.38s user 2.04s system 99% cpu 2.436 total
./performance_test  0.36s user 2.03s system 99% cpu 2.411 total
```]

比較回数は、
#sourcecode[```bash
$ ./performance_test | wc -l
2090000
```]

なお、ヒープソートにおける、時間と比較回数は
#sourcecode[```bash
./performance_test  0.40s user 2.23s system 99% cpu 2.643 total
./performance_test  0.39s user 2.20s system 98% cpu 2.633 total
./performance_test  0.34s user 2.26s system 99% cpu 2.612 total
./performance_test  0.42s user 2.20s system 99% cpu 2.640 total
./performance_test  0.39s user 2.28s system 99% cpu 2.688 total
```]

#sourcecode[```bash
$ ./performance_test | wc -l
2230000
```]


以上をグラフにまとめると以下のようになり、
平均的には明らかにクイックソートは比較回数、時間ともに小さく、ヒープソートと比べて性能が良いことが分かる。

一方で、計算量が最悪の場合、クイックソートは大幅に時間、比較回数ともに大きくなり、性能が下がることが分かる。
しかし、ヒープソートはあまり影響を受けない。

なお、今回の実装及び計測ではどちらにせよクイックソートのほうがヒープソートと比べると時間、比較回数ともに小さくて済むという結果にはなっている。

#figure(
  image("./compare-graph.png"),
  caption: [比較回数が小さく時刻も小さい群がクイックソート、どちらも大きい群がヒープソートである(2300000前後両方の群がヒープソートであり、もとの整列状態に影響をあまり受けないことが分かる)。2100000回周辺の群は最悪の場合のクイックソートである。]
)

#bibliography-list(
  title: "参考文献", // 節見出しの文言
)[
#bib-item(<textbook>)[未来へつなぐデジタルシリーズ10 アルゴリズムとデータ構造 共立出版株式会社, https://www.kyoritsu-pub.co.jp/book/b10008170.html, 2025 年 12 月 8 日閲覧]
]
