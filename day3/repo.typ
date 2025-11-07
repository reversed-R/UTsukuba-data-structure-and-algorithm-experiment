#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/showybox:2.0.4": showybox
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "課題3",
  subtitle: "ハッシュ法",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "2025 年 11 月 7 日",
)

== 基本課題

=== 3-3

`DictOpenAddr`の実装についてそれぞれの操作を要件通り書いた。

==== 全体の実行結果

もともと与えられた`main`
#sourcecode[```c
#include "open_addressing.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  DictOpenAddr *test_dict = create_dict(10);

  insert_hash(test_dict, 1);
  insert_hash(test_dict, 2);
  insert_hash(test_dict, 3);
  insert_hash(test_dict, 11);
  insert_hash(test_dict, 12);
  insert_hash(test_dict, 21);
  display(test_dict);

  printf("Search 1 ...\t%d\n", search_hash(test_dict, 1));
  printf("Search 2 ...\t%d\n", search_hash(test_dict, 2));
  printf("Search 21 ...\t%d\n", search_hash(test_dict, 21));
  printf("Search 5 ...\t%d\n", search_hash(test_dict, 5));

  delete_hash(test_dict, 3);
  display(test_dict);

  delete_hash(test_dict, 11);
  display(test_dict);

  delete_dict(test_dict);

  return EXIT_SUCCESS;
}
```]

を用いると、以下の出力

#sourcecode[```bash
$ ./open_addressing
e 1 2 3 11 12 21 e e e
Search 1 ...    1
Search 2 ...    2
Search 21 ...   6
Search 5 ...    -1
e 1 2 d 11 12 21 e e e
e 1 2 d d 12 21 e e e
```]

が得られ、少なくともこのレベルの要件は満たしていると分かる。

==== 個別の機能の実装と実行結果など

- 辞書自身の作成
#sourcecode[```c
DictOpenAddr *create_dict(int len) {
  DictOpenAddr *dict = (DictOpenAddr *)malloc(sizeof(DictOpenAddr));
  dict->H = (DictData *)malloc(sizeof(DictData) * len);
  dict->B = len;

  // すべてのデータ領域を空で初期化
  for (int i = 0; i < len; i++) {
    DictData d = dict->H[i];
    d.state = EMPTY;
  }

  return dict;
}
```]
辞書自身と辞書のデータが格納される長さ`len`の配列を`malloc()`でヒープに確保する。

すべてのデータ領域を空`State EMPTY`で初期化する。


- ハッシュ関数
#sourcecode[```c
int h(DictOpenAddr *dict, int d, int count) {
  return (d + count) % dict->B;
}
```]

格納するデータ自身`d`のハッシュを取るが再ハッシュが発生しうるため`count`をハッシュに含めるというのが必要な方針である。

`h0()`に`h()`自身を用いる場合、剰余の等価性の関係により、結局`d`自身を用いても同じ結果が得られるためこのように実装した。

これにより`h()`を再帰呼出しをすることによる計算コストを除去できる。

もしくは再ハッシュをする側が前回のハッシュの結果を`d`に渡すと良いかもしれない(今回はそれをしなくても同じ結果が得られるためそうしなかった)。

- データの挿入
#sourcecode[```c
void insert_hash(DictOpenAddr *dict, int d) {
  // 安全のため、dictのlen回以上空きスロットを探索した場合は辞書自体のオーバフローとしてエラー終了
  for (int i = 0; i < dict->B; i++) {
    int hash = h(dict, d, i);
    DictData *data = &dict->H[hash];

    switch (data->state) {
    case EMPTY:
      data->name = d;
      data->state = OCCUPIED;
      return;
    case DELETED:
      if (data->name == d) {
        return;
      }
      continue;
    case OCCUPIED:
      continue;
    }
  }

  fprintf(stderr, "dictionary overflowed!!\n");
  exit(EXIT_FAILURE);
}
```]

ハッシュ関数で得られたインデックスが空きスロットならそこにデータを挿入し、状態を占有済み`OCCUPIED`に変更する。

オープンアドレス法であり、上記のようなハッシュ関数を用いているため、空`EMPTY`または削除済み`DELETED`の空きのスロットが見つかるまで1つ次のスロットを見て回ることになる。

再ハッシュ回数が辞書の長さを超えた場合は、すなわち辞書内に空きスロットがない場合なので、エラーとして強制終了する。

ここで実際にオーバーフローが発生した際にエラー終了することを検証するために以下のテストコードを実行した。

長さ10の辞書に対して11の要素を挿入する。
#sourcecode[```c
#include "open_addressing.h"
#include <stdlib.h>

int main(void) {
  DictOpenAddr *test_dict = create_dict(10);

  for (int i = 0; i < 11; i++) {
    insert_hash(test_dict, i * 10 + 3);

    display(test_dict);
  }

  delete_dict(test_dict);

  return EXIT_SUCCESS;
}
```]

以下のようなエラー終了が起きるため、正しいと分かる。
#sourcecode[```bash
$ ./open_addressing_test
e e e 3 e e e e e e
e e e 3 13 e e e e e
e e e 3 13 23 e e e e
e e e 3 13 23 33 e e e
e e e 3 13 23 33 43 e e
e e e 3 13 23 33 43 53 e
e e e 3 13 23 33 43 53 63
73 e e 3 13 23 33 43 53 63
73 83 e 3 13 23 33 43 53 63
73 83 93 3 13 23 33 43 53 63
dictionary overflowed!!
```]

また、初回で得られるハッシュ値が被るように設定したため、再ハッシュされて1スロットずつ次に値が挿入されていっていることを検証できた。

- 辞書の探索, 削除
#sourcecode[```c
int search_hash(DictOpenAddr *dict, int d) {
  for (int i = 0; i < dict->B; i++) {
    int hash = h(dict, d, i);
    DictData *data = &dict->H[hash];
    if (data->name == d && data->state == OCCUPIED) {
      return hash;
    }
  }

  return -1;
}

void delete_hash(DictOpenAddr *dict, int d) {
  for (int i = 0; i < dict->B; i++) {
    int hash = h(dict, d, i);
    DictData *data = &dict->H[hash];
    if (data->name == d && data->state == OCCUPIED) {
      data->state = DELETED;
      return;
    }
  }
}
```]

探索、削除とも、目的のデータが見つかるまで再ハッシュを繰り返し、見つかればその操作を行い終了、全データを走査し終えたら見つからなかったとして終了するだけである。


以下のテストコードで、2を削除したのちハッシュ値が被る12を挿入すると正しく挿入されることを検証した。
#sourcecode[```c
#include "open_addressing.h"
#include <stdlib.h>

int main(void) {
  DictOpenAddr *test_dict = create_dict(10);

  insert_hash(test_dict, 2);
  insert_hash(test_dict, 3);

  display(test_dict);

  delete_hash(test_dict, 2);

  display(test_dict);

  insert_hash(test_dict, 12);

  display(test_dict);

  delete_dict(test_dict);

  return EXIT_SUCCESS;
}
```]

出力。
#sourcecode[```bash
$ ./open_addressing_test
e e 2 3 e e e e e e
e e d 3 e e e e e e
e e 12 3 e e e e e e
```]


- 辞書の全走査による出力
#sourcecode[```c
void display(DictOpenAddr *dict) {
  for (int i = 0; i < dict->B; i++) {
    DictData data = dict->H[i];

    switch (data.state) {
    case EMPTY:
      printf("e ");
      break;
    case OCCUPIED:
      printf("%d ", data.name);
      break;
    case DELETED:
      printf("d ");
      break;
    }
  }

  printf("\n");
}
```]

特徴的な分岐(終了条件)もなく、ただ全データを総なめしてその状態に従って出力するだけである。

- 辞書自身の削除
#sourcecode[```c
void delete_dict(DictOpenAddr *dict) {
  if (dict != NULL) {
    free(dict->H);
    free(dict);
  }
}
```]

辞書自身だけでなく同時に確保した辞書のデータを格納する配列も(`dict`自身が`NULL`であっても`free()`は`NULL`に対して何もしないので問題ないが、メンバである`H`についてはアクセスできることを保証する必要があるため`NULL`チェックをして)`free()`する必要があることに注意。


// #bibliography-list(
//   title: "参考文献", // 節見出しの文言
// )[
// #bib-item(<euclid-calc-order>)["", http://example.com, 2025 年 10 月 15 日閲覧]
// ]
