#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第6回",
  subtitle: "グラフアルゴリズム：DijkstraのアルゴリズムおよびFloydのアルゴリズムの実装",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "2026 年 1 月 5 日",
)

== 6.1 Dijkstra法の実装

すでに示されたコードのうち`add()`, `remain()`, `select_min()`, `member()`の具体実装と、`dijkstra()`の修正を行った。

いかにそのコードを示す。

=== `add()`

$u$を集合$S$に追加することは、配列`S`のインデックス`u`の値を`true`にすることで記述できる。
#sourcecode[```c
/**
 * 頂点集合 S に頂点 u を追加する．
 * @param u 追加する頂点
 * @param S 頂点集合
 * @return なし
 */
void add(int u, bool S[]) { S[u] = true; }
```]

=== `remain()`

追加されていない頂点があるかは、配列`S`の要素に`false`のものがあるかを走査すれば良い。
#sourcecode[```c
/**
 * 頂点集合のうち S に追加されていない頂点があるかどうか確認する．
 * @return S に追加されていない頂点が存在すれば true，それ以外は false
 */
bool remain() {
  for (int i = 0; i < N; i++) {
    if (!S[i]) {
      return true;
    }
  }

  return false;
}
```]

=== `select_min()`

配列`d`を総なめして、最小のもののインデックスを返す。

ただし、未確定であるという条件を満たすために`S[i] == false`であることを検査する。
#sourcecode[```c
/**
 * p からの最短距離が確定していない頂点のうち，d[] が最小の頂点を
 * 返す．
 * @param なし
 * @return 未確定の d[] が最小の頂点
 */
int select_min() {
  int min = M;
  int min_idx = -1;
  for (int i = 0; i < N; i++) {
    if (!S[i] && d[i] < min) {
      min = d[i];
      min_idx = i;
    }
  }

  return min_idx;
}
```]

=== `member()`

隣接行列`w`では接続する辺が存在しないことを`M`(`INT_MAX`)で表しているため、そうでないかを検査する。
#sourcecode[```c
/**
 * 頂点 u から頂点 x に接続する辺が存在すれば true, それ以外は
 * false を返す.
 * @param u 頂点
 * @param x 頂点
 * @return 辺が存在すれば true, それ以外は false
 */
bool member(int u, int x) { return w[u][x] != M; }
```]

=== `dijkstra()`

示されたコードをそのまま使うと、_(X)_で`INT_MAX`であるところの`M`に加算を行い、
オーバーフローしてしまう。

実際、回避処理を施していない場合のグラフ2についての実行結果である以下では、オーバーフローが見受けられる。
#sourcecode[```c
$ ./main_dijkstra 1
d: [ 28 -2147483617 81 -2147483617 14 -2147483568 77 -2147483572 ]
```]

そこで、`add_without_overflow()`にて、オーバーフローを回避する処理を入れている。

#sourcecode[```c
int add_without_overflow(int x, int y) {
  if (x == INT_MAX || y == INT_MAX) {
    return INT_MAX;
  } else {
    return x + y;
  }
}

/**
 * ダイクストラ法で，頂点 p から各頂点への最短路の重みを計算する．
 * @param p 開始点
 * @return なし
 */
void dijkstra(int p) {
  add(p, S);

  for (int i = 0; i < N; i++)
    d[i] = w[p][i];

  while (remain()) {
    int u = select_min();
    if (u == -1)
      break;
    else
      add(u, S);

    for (int x = 0; x < N; x++) {
      if (member(u, x)) {
        // M (= INT_MAX)に加算するとオーバーフローして負になってしまうのを回避
        int k = add_without_overflow(d[u], w[u][x]); // (X)
        if (d[x] == M)
          d[x] = k;
        else if (k < d[x])
          d[x] = k;
      }
    }
  }
}
```]

=== 動作の検証

実行結果は以下のとおりである。

グラフ1の場合
#sourcecode[```bash
$ ./main_dijkstra 1
d: [ M 0 43 3 40 24 33 12 ]
$ ./main_dijkstra 2
d: [ M 44 0 31 75 9 18 47 ]
$ ./main_dijkstra 3
d: [ M 13 56 0 53 37 46 25 ]
```]

グラフ2の場合
#sourcecode[```bash
$ ./main_dijkstra 1
d: [ 28 0 81 57 14 58 77 32 ]
$ ./main_dijkstra 2
d: [ M 2 0 M 27 78 97 52 ]
$ ./main_dijkstra 3
d: [ M M M 0 M M M M ]
```]

これらは手計算したときの結果と一致しており、動作の検証ができた。

== Dijkstra法における最短路の表示

=== `display_path()`

今いるノードが`node`であるとき、`parent[node]`がその前に通過するノードであり、
`parent[parent[node]]`がさらにその前に通過するノードであり...という方法で通ってきた経路を辿ることが出来る。

問題は、前の経路を辿っていくと求めたい経路の逆順が得られることであり、これを開始ノードから終了ノードへの正順に変換したい。

通常スタックなどを使って正順にするが、ここでは関数のコールスタック自体をスタックとして活用し、`display_parent_path()`にて、
再帰的に前の経路を探索してから現在の経路を出力するということを行うことで、求めたい経路を得る実装をした。

#sourcecode[```c
void display_parent_path(int origin, int *parent, int node) {
  if (node != origin) {
    int prnt = parent[node];
    display_parent_path(origin, parent, prnt);
    printf(" %d", prnt);
  }
}

/**
 * display_path 配列を元に各頂点からの最短経路を表示．
 * @param parent int配列
 * @param origin 出発点
 * @return なし
 */
void display_path(int *parent, int origin) {
  for (int i = 0; i < N; i++) {
    if (d[i] == M) {
      printf("From %d to %d (w = M): unreachable\n", origin, i);
    } else {
      printf("From %d to %d (w = %d):", origin, i, d[i]);
      display_parent_path(origin, parent, i);
      printf(" %d", i);
      printf("\n");
    }
  }
}
```]

=== `dijkstra()`

_(A)_と_(B)_にて`parent`の更新を追加。

同様にオーバーフローを回避する処理を入れている。

#sourcecode[```c
/**
 * ダイクストラ法で，頂点 p から各頂点への最短路の重みを計算する．
 * @param p 開始点
 * @return なし
 */
void dijkstra(int p) {
  add(p, S);

  for (int i = 0; i < N; i++) {
    d[i] = w[p][i];
    parent[i] = p; // (A)
  }

  while (remain()) {
    int u = select_min();
    if (u == -1)
      break;
    else
      add(u, S);

    for (int x = 0; x < N; x++) {
      if (member(u, x)) {
        // M (= INT_MAX)に加算するとオーバーフローして負になってしまうのを回避
        int k = add_without_overflow(d[u], w[u][x]);
        if (d[x] == M) {
          d[x] = k;
          parent[x] = u; // (B)
        } else if (k < d[x])
          d[x] = k;
      }
    }
  }
}
```]

=== 動作の検証

実行結果は以下のとおりである。

グラフ1の場合
#sourcecode[```bash
$ ./main_dijkstra_path 1
d: [ M 0 43 3 40 24 33 12 ]
From 1 to 0 (w = M): unreachable
From 1 to 1 (w = 0): 1
From 1 to 2 (w = 43): 1 7 5 2
From 1 to 3 (w = 3): 1 3
From 1 to 4 (w = 40): 1 7 4
From 1 to 5 (w = 24): 1 7 5
From 1 to 6 (w = 33): 1 7 5 6
From 1 to 7 (w = 12): 1 7
$ ./main_dijkstra_path 2
d: [ M 44 0 31 75 9 18 47 ]
From 2 to 0 (w = M): unreachable
From 2 to 1 (w = 44): 2 5 3 1
From 2 to 2 (w = 0): 2
From 2 to 3 (w = 31): 2 5 3
From 2 to 4 (w = 75): 2 5 6 7 4
From 2 to 5 (w = 9): 2 5
From 2 to 6 (w = 18): 2 5 6
From 2 to 7 (w = 47): 2 5 6 7
```]

グラフ2の場合
#sourcecode[```bash
$ ./main_dijkstra_path 1
d: [ 28 0 37 23 14 58 20 32 ]
From 1 to 0 (w = 28): 1 0
From 1 to 1 (w = 0): 1
From 1 to 2 (w = 37): 1 0 2
From 1 to 3 (w = 23): 1 4 6 3
From 1 to 4 (w = 14): 1 4
From 1 to 5 (w = 58): 1 4 7 5
From 1 to 6 (w = 20): 1 4 6
From 1 to 7 (w = 32): 1 4 7
$ ./main_dijkstra_path 2
d: [ 30 2 0 25 16 60 22 34 ]
From 2 to 0 (w = 30): 2 1 0
From 2 to 1 (w = 2): 2 1
From 2 to 2 (w = 0): 2
From 2 to 3 (w = 25): 2 4 6 3
From 2 to 4 (w = 16): 2 4
From 2 to 5 (w = 60): 2 4 7 5
From 2 to 6 (w = 22): 2 4 6
From 2 to 7 (w = 34): 2 4 7
```]

これらは手計算したときの結果と一致しており、動作の検証ができた。

== Floydのアルゴリズムの実装

=== `floyd()`

1. 経由ノードでループを回し、
2. さらに開始ノードでループを回し、
3. さらに終了ノードでループを回し、
4. 開始ノード $->$ 経由ノード $->$ 終了ノードの加算した距離が、開始ノード $->$ 終了ノードの距離より短ければ更新する。ただし、同様にオーバーフローを回避する処理を入れている。

#sourcecode[```c
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
```]

== `shortest_path()`と関連するスタック操作関数

こちらもdijkstra同様に、前ホップを格納した配列から辿っていくことで最短経路の逆順が得られる。

つまり、`m`から`n`への最短経路は

`m` $->$ ... $->$ `p[m][p[m][n]]` $->$ `p[m][n]` $->$ `n`

のように表される。

今回はすでにスタック用変数が定義されていたのでそれを活用した。

スタック操作については基本的なpush, pop, emptyのみであり、
いずれもスタックの上限(スタックサイズ`N`)とスタックの底との境界チェックを行いつつ、
スタックトップのポインタである`stack_p`を変更するように実装した。

#sourcecode[```c
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
```]

=== 動作の検証

実行結果は以下のとおりである。

グラフ1の場合のみ

#sourcecode[```bash
❯ ./main_floyd
From 0 to 0 (w = 0): 0
From 0 to 1 (w = 22): 0 7 1
From 0 to 2 (w = 42): 0 7 5 2
From 0 to 3 (w = 25): 0 7 1 3
From 0 to 4 (w = 39): 0 7 4
From 0 to 5 (w = 23): 0 7 5
From 0 to 6 (w = 32): 0 7 5 6
From 0 to 7 (w = 11): 0 7
From 1 to 0 (w = M): unreachable
From 1 to 1 (w = 0): 1
From 1 to 2 (w = 43): 1 7 5 2
From 1 to 3 (w = 3): 1 3
From 1 to 4 (w = 40): 1 7 4
From 1 to 5 (w = 24): 1 7 5
From 1 to 6 (w = 33): 1 7 5 6
From 1 to 7 (w = 12): 1 7
From 2 to 0 (w = M): unreachable
From 2 to 1 (w = 44): 2 5 3 1
From 2 to 2 (w = 0): 2
From 2 to 3 (w = 31): 2 5 3
From 2 to 4 (w = 75): 2 5 6 7 4
From 2 to 5 (w = 9): 2 5
From 2 to 6 (w = 18): 2 5 6
From 2 to 7 (w = 47): 2 5 6 7
From 3 to 0 (w = M): unreachable
From 3 to 1 (w = 13): 3 1
From 3 to 2 (w = 56): 3 1 7 5 2
From 3 to 3 (w = 0): 3
From 3 to 4 (w = 53): 3 1 7 4
From 3 to 5 (w = 37): 3 1 7 5
From 3 to 6 (w = 46): 3 1 7 5 6
From 3 to 7 (w = 25): 3 1 7
From 4 to 0 (w = M): unreachable
From 4 to 1 (w = 32): 4 7 1
From 4 to 2 (w = 52): 4 7 5 2
From 4 to 3 (w = 35): 4 7 1 3
From 4 to 4 (w = 0): 4
From 4 to 5 (w = 33): 4 7 5
From 4 to 6 (w = 42): 4 7 5 6
From 4 to 7 (w = 21): 4 7
From 5 to 0 (w = M): unreachable
From 5 to 1 (w = 35): 5 3 1
From 5 to 2 (w = 19): 5 2
From 5 to 3 (w = 22): 5 3
From 5 to 4 (w = 66): 5 6 7 4
From 5 to 5 (w = 0): 5
From 5 to 6 (w = 9): 5 6
From 5 to 7 (w = 38): 5 6 7
From 6 to 0 (w = M): unreachable
From 6 to 1 (w = 40): 6 7 1
From 6 to 2 (w = 60): 6 7 5 2
From 6 to 3 (w = 43): 6 7 1 3
From 6 to 4 (w = 57): 6 7 4
From 6 to 5 (w = 41): 6 7 5
From 6 to 6 (w = 0): 6
From 6 to 7 (w = 29): 6 7
From 7 to 0 (w = M): unreachable
From 7 to 1 (w = 11): 7 1
From 7 to 2 (w = 31): 7 5 2
From 7 to 3 (w = 14): 7 1 3
From 7 to 4 (w = 28): 7 4
From 7 to 5 (w = 12): 7 5
From 7 to 6 (w = 21): 7 5 6
From 7 to 7 (w = 0): 7
```]

これらは手計算したときの結果と一致しており、動作の検証ができた。

// #sourcecode[```c
// ```]

// #sourcecode[```c
// ```]

// hogehoge @reference
//
// #bibliography-list(
//   title: "参考文献", // 節見出しの文言
// )[
// #bib-item(<reference>)[参考文献の名前, https://reference.info.com/reference.html, yyyy 年 mm 月 dd 日閲覧]
// ]
