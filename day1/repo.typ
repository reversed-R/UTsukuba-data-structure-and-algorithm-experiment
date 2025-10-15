#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/showybox:2.0.4": showybox
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "課題1",
  subtitle: "C言語によるプログラミングの復習",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "2025 年 10 月 15 日",
)

== 基本課題

=== 2

`gcd_euclid`の実装は以下のとおり。

#sourcecode[```c
int gcd_euclid(int n, int m) {
  int p = n, q = m;
  while (1) {
    if (q > p) {
      int tmp = p;
      p = q;
      q = tmp;
    }

    if (q == 0) {
      return p;
    }

    int tmp = q;
    q = p % q;
    p = tmp;
  }

  return p;
}
```]

実行結果は以下のとおり。

#sourcecode[```sh
$ ./gcd_euclid 60 105
The GCD of 60 and 105 is 15.
```]

=== 3

+ `gcd_iter`は$m$が$n$より大きくなるようにし、$1 <= i <= n$の範囲の$i$をループでインクリメントして総なめし、$n$と$m$が割り切れるものがあればそれを解として更新する。
  したがって、$6, 15$を入力に取る場合、$i$は$1$で始まり、$i = 3$のとき$gcd$が更新され、$i = 6$のとき$gcd$が更新されて終了する。
  ループの回数は常に小さいほうの数の回数かかる($6, 15$なら6回)。

+ `gcd_euclid`は
  $6, 15$を入力に取る場合、$p = 15, q = 6$となり、はじめのループで$15 % 6 = 3$で$q$が更新され(同時に$p = 6$に更新される)、次に$6 % 3 = 0$で$q$が更新され(同時に$p = 3$に更新される)、3回目のループで$q = 0$より$p = 3$を返す。
  ループの回数が3回で済む。


== 発展課題

=== 1

2つの入力の整数を$N, M (N > M)$とする。

+ `gcd_iter`のループの回数は常に小さいほうの数の回数かかる。
  したがって、時間計算量は$O(N)$
  領域計算量はループ内での使用メモリはこの場合0で一定で、$gcd, i$の2変数を宣言する分(現在の主流な処理系で32bitが2つで64bit)のみである。

+ `gcd_euclid`は毎回のステップで片方の数が相当小さくなることが期待される。
  時間計算量は$N$より小さい数($log N$くらいと想像する)に比例するのではないかと想像する。

  調べたところ、そのとおりでユークリッドの互除法の時間計算量は$log N$らしい。 @euclid-calc-order
  
  領域計算量はループ内での使用メモリはこの場合$t m p$のための領域で一定で、$p, q$の2変数を宣言する分と合わせた分(現在の主流な処理系で32bitが3つで96bit)のみである。

=== 2

`gcd_recursive`の実装は以下のとおり。

#sourcecode[```c
int gcd_recursive(int n, int m) {
  int p = n, q = m;
  if (m > n) {
    p = m;
    q = n;
  }

  if (q == 0) {
    return p;
  }

  return gcd_recursive(q, p % q);
}
```]

+ `gcd_recursive`は
  本質的には`gcd_euclid`と同じステップを踏む。
  しかし、再帰的に関数自身を呼び出している。
  再帰呼出しはCの場合呼び出しのたびに新たにコールスタックが確保されるためメモリ効率的に良いとは言えない。
  が、末尾再帰の最適化は等価なループに書き換えるなど近年のコンパイラの最適化を持ってすればループと同じ効率になることも多い。



#bibliography-list(
  title: "参考文献", // 節見出しの文言
)[
#bib-item(<euclid-calc-order>)["東北大学情報科学研究科 塩浦昭義『アルゴリズムとデータ構造』", http://www.shioura-lab.iee.e.titech.ac.jp/shioura/teaching/ad10/ad10-01.pdf, 2025 年 10 月 15 日閲覧]
]
