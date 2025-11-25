#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第4回",
  subtitle: "2分木、2分探索木",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "2025 年 11 月 25 日",
)

== 4.2 二分木の実装

もとから`main_binarytree.c`にあるテストケースは以下の木を表している。

#image("images/q4-2-1.png")

これを実行すると以下の結果が得られ、

#sourcecode[```bash
$ ./binarytree
PRE: C A I D F L G
IN: I A F D C L G
POST: I F D A G L C
BFS: C A L I D G F
TREE: C(A(I(null,null),D(F(null,null),null)),L(null,G(null,null)))
height: 4
```]

図と比較すると、
+ 行きがけ順(`PRE`)
+ 通りがけ順(`IN`)
+ 帰りがけ順(`POST`)
+ 幅優先探索(`BFS`)
+ 木全体の表示(`TREE`)
+ 高さの取得(`height`)

のいずれもが正しいことが分かる(また、関連して節の作成も正しいと分かる)。

これ以上のテストケースを増やすことはテストの精度が上がるだけであり、
少なくともこの(別に単純ではない)テストケースを満たしているため十分に仕様を満たしていると判断した。

以下、それぞれの実装がロジック的に正しいことを示していく。

=== 節の作成

以下のように節のサイズのメモリを動的に確保し、与えられた値を詰めた後、そのポインタを返すだけである。

#sourcecode[```c
Node *create_node(char *label, Node *left, Node *right) {
  // ラベルは必ず必要であるものとし、NULLである時点でNodeを作成しない
  if (label == NULL) {
    return NULL;
  }

  Node *node = (Node *)malloc(sizeof(Node));
  node->label = label;
  node->left = left;
  node->right = right;

  return node;
}
```]

=== 行きがけ順での走査

コメントにあるとおり、仕様にある`preorder()`は仕様の通りの出力の最初と最後を出すのみで、
再帰的に実行される本体は`preorder_subtree()`である。

以降通りがけ順や帰りがけ順などについても、仕様の関数は出力の調整のみを行い、`*_subtree()`関数が再帰的に出力を行う本体となるような実装をした。

`*_subtree()`関数が一番重要であり、この出力順序により行きがけ、通りがけのような順が決定される。

`preorder_subtree()`では、
1. まず自身のラベルを出力し、
2. 左の木について再帰的に自身を呼び出してラベルを出力し、
3. 右の木について再帰的に自身を呼び出してラベルを出力する
という順で走査が行われる。

教科書 @textbook 40ページ リスト2.11 にも同様の記述があり、
この順序により順(今回は行きがけ順)が実現できると分かる。


#sourcecode[```c
// NOTE: 行きがけ順で出力する本体
void preorder_subtree(Node *n) {
  if (n != NULL) {
    printf("%s ", n->label);
    preorder_subtree(n->left);
    preorder_subtree(n->right);
  }
}

// NOTE:
// 行きがけ順での出力を与えられたノードから呼び出すだけ。出力の指定に、最初の`PRE:
// `, 最後の`\n`が含まれる為必要。
void preorder(Node *n) {
  printf("PRE: ");
  preorder_subtree(n);
  printf("\n");
}
```]

=== 通りがけ順での走査

上で説明した通りであり、`inorder_subtree()`内での走査順序を
1. 左部分木
2. 自身
3. 右部分木
としている。

#sourcecode[```c
// NOTE: 通りがけ順で出力する本体
void inorder_subtree(Node *n) {
  if (n != NULL) {
    inorder_subtree(n->left);
    printf("%s ", n->label);
    inorder_subtree(n->right);
  }
}

// NOTE:
// 通りがけ順での出力を与えられたノードから呼び出すだけ。
void inorder(Node *n) {
  printf("IN: ");
  inorder_subtree(n);
  printf("\n");
}
```]



=== 帰りがけ順での走査

上で説明した通りであり、`postorder_subtree()`内での走査順序を
1. 左部分木
2. 自身
3. 右部分木
としている。

#sourcecode[```c
// NOTE: 帰りがけ順で出力する本体
void postorder_subtree(Node *n) {
  if (n != NULL) {
    postorder_subtree(n->left);
    postorder_subtree(n->right);
    printf("%s ", n->label);
  }
}

// NOTE:
// 帰りがけ順での出力を与えられたノードから呼び出すだけ。
void postorder(Node *n) {
  printf("POST: ");
  postorder_subtree(n);
  printf("\n");
}
```]



=== 木全体の表示

こちらも構造としては上とほとんど同様である。

`display_subtree()`内では(表示を要件に合わせるために`printf()`が多いが、本質的には)、

1. 自身のラベルを出力し、
2. 左部分木を出力し、
3. 右部分木を出力する
というだけである。

ただし、節自身が`NULL`なら要件通り`null`と出力する。

#sourcecode[```c
// NOTE:
// 最後(のみ?)に改行を入れるという要件のせいでdisplay_subtree()を作らなければならなくなった。
// Cなので仕方ないのだが、sprintf()などであふれるかもしれないバッファに文字列を結合するよりは、いちいち標準出力に出したほうが安全なので、
// このダサいprintf()まみれになった。
void display_subtree(Node *n) {
  if (n != NULL) {
    printf("%s(", n->label);
    display_subtree(n->left);
    printf(",");
    display_subtree(n->right);
    printf(")");
  } else {
    printf("null");
  }
}

void display(Node *n) {
  printf("TREE: ");
  display_subtree(n);
  printf("\n");
}
```]


=== 高さの取得

以下のように、
- 自身が`NULL`なら`0`を返し、
- そうでなければ左部分木と右部分木の高さを再帰的に取得して高い方の高さと自信を考慮して`1`を足したものを返す、
ことで再帰的な走査が行われ最大の高さが得られる。

#sourcecode[```c
int height(Node *n) {
  if (n == NULL) {
    return 0;
  } else {
    int lheight = height(n->left);
    int rheight = height(n->right);

    return 1 + (lheight > rheight ? lheight : rheight);
  }
}
```]


=== 木の削除

以下のように、左右の部分木を再帰的に削除することを忘れないようにして削除するだけである。

コメントのように、文字列は外部からそのポインタが与えられているため解放しない(してはならないし、BSSなどそもそも解放の対象ではない領域に確保されている可能性が高い)。

#sourcecode[```c
// NOTE: 指示に `文字列のメモリ扱いを忘れないように注意すること` とあるが、
// 外部から文字列を渡すシグニチャが要件であり、
// 実際与えられたmainのように文字列リテラルでラベルを渡すなどNode側の管理の範囲外であるため、
// 全く何もしなくて良い。
void delete_tree(Node *n) {
  if (n != NULL) {
    delete_tree(n->left);
    delete_tree(n->right);
    free(n);
  }
}
```]


=== 幅優先探索

二分木において最も実装が困難であったのが幅優先探索である。

コメントに部分的に余計なことが書いてあるが、
重要なのは、
1. 根から順に等しい高さの節を走査して行く際に通った順に節のポインタをキューにエンキューしていき、
2. 次の高さの走査をする際には前の高さの節のポインタのキューからデキューした順(FIFOで取り出せる)に同様に走査する
ことを繰り返すことで幅優先での走査順が実現できることである。

ポインタが格納可能なキューを用意するために前回の`Queue`に`int`ではなく`void*`が入るように変更を加えた(逆にそれ以外は変更していない)。

以下のコードでは上を実現するために、
1. 外の`while`で各高さの繰り返しを実現し、`Queue * current_nodes`に現在の高さでの節をエンキューしていき、
2. 内側の`for`で、`current_nodes`がある分だけデキューして、ラベルを出力すると同時に、その子(次の高さ)が存在すれば左右の順でそれを次の高さの節のキュー`Queue * next_nodes`にエンキューしていく。
  最後に`current_nodes`に`next_nodes`を代入して次の高さに操作を移す

ことを行っている。

#sourcecode[```c
// WARN: 引数のnodesは勝手にこの中でfree()されることに注意
void breadth_first_search_subtree(Queue *nodes) {
  // WARN: nodes が NULL の場合のことは考えない
  if (nodes != NULL) {
    Queue *current_nodes = nodes;
    int current_node_count = 1;

    while (current_node_count > 0) {
      Queue *next_nodes = create_queue(QUEUE_BUFSIZE);
      int next_node_count = 0;

      for (int i = 0; i < current_node_count; i++) {
        Node *n = (Node *)dequeue(current_nodes);

        if (n != NULL) {
          printf("%s ", n->label);
          if (n->left != NULL) {
            enqueue(next_nodes, n->left);
            next_node_count++;
          }
          if (n->right != NULL) {
            enqueue(next_nodes, n->right);
            next_node_count++;
          }
        }
      }

      delete_queue(current_nodes);
      current_nodes = next_nodes;
      current_node_count = next_node_count;
    };
  }
}

// NOTE:
// C言語なので逐次的にprintf()しまくり副作用ありまくりのコードを書けばいいという説もあるが、
// キューを上手く活用することとあるし、せっかくすでにキューを実装してあることだし、使うことにした。
// と思ったが、display()という安直な名前をこちらとqueueのどちらでも使っているためにそのままは使えなかった。
// もっと特定性のある命名をすべきだと思う。
// というかそもそもキューの構造の出番とは思えない
// いやまあ使えはした
void breadth_first_search(Node *n) {
  printf("BFS: ");

  if (n != NULL) {
    Queue *nodes = create_queue(QUEUE_BUFSIZE);

    // NOTE: Node*を格納するために int を格納するQueueを
    // void*を格納するように変更した。
    enqueue(nodes, n);

    breadth_first_search_subtree(nodes);
  }

  printf("\n");
}
```]


== 4.3 二分探索木の実装

もとの`main_binarysearchtree.c`にあるテストケースは以下のような木である。

#image("images/q4-3-1.png")

実行すると以下出力が得られ、

#sourcecode[```c
$ ./binarysearchtree
IN: 5 10 13 14 20 26
TREE: 20(10(5(null,null),14(13(null,null),null)),26(null,null))
search_bst 14: 1
search_bst 7: 0
min_bst: 5
IN: 5 13 14 20 26
TREE: 20(13(5(null,null),14(null,null)),26(null,null))
```]

想定される出力と一致しており、

図と比較すると、
+ 通りがけ順(`IN`)の出力が数の小さい順になっていること
+ 木全体の表示(`TREE`)
+ 指定された値の探索(存在する場合、存在しない場合いずれも)
  + `14`は存在し、`1` (`stdbool.h true`の値は`1`として定義されているため正しい)
  + `7`は存在し、`0` (`stdbool.h false`の値は`0`として定義されているため正しい)
+ 最小値の取得(`5`)
+ 節の削除(その後の出力が想定されるものであることから正しいと分かる)
のいずれも正しいと分かる。

以下各部分についてロジックが正しく実装されていることを示していく。

=== 最小値の取得

`min_bst_subtree()`によって左部分木を再帰的に探索し、`NULL`でない限り与えられた整数のポインタを更新するため、
最小値が得られる。

#sourcecode[```c
void min_bst_subtree(Node *n, int **res) {
  if (n != NULL) {
    **res = n->value;

    int subres;
    int *psubres = &subres;
    min_bst_subtree(n->left, &psubres);

    // NOTE: psubres が NULL でないとき、subres
    // が再帰的に探索したときの最小値に更新されている。
    if (psubres != NULL) {
      **res = subres;
      return;
    }
  } else {
    *res = NULL;
    return;
  }
}

int min_bst(Node *root) {
  if (root != NULL) {
    int res;
    int *pres = &res;

    min_bst_subtree(root, &pres);

    return res;
  } else {
    return -1;
  }
}
```]

=== 指定された値の探索

現在いる節が`NULL`ならば(すなわち目的の節を発見できないまま木の葉に到達したということであるため)直ちに`false`を返し、
現在いる節と等しければ`true`を返し、
それ以外の場合は現在いる節と比較して、
  指定された値のほうが大きければ右部分木を
  そうでなければ左部分木を
再帰的に探索することで、目的の探索が行える。

#sourcecode[```c
bool search_bst(Node *root, int d) {
  if (root != NULL) {
    if (root->value == d) {
      return true;
    } else if (root->value < d) {
      return search_bst(root->right, d);
    } else {
      return search_bst(root->left, d);
    }
  } else {
    return false;
  }
}
```]

=== 値の挿入

与えられた`root`へのダブルポインタの1回デリファレンスが`NULL`である場合、木が空であることになるためそこに節を挿入する。

そうでなければ上の探索と同様に
+ すでに同じ値があれば何もしない。
+ そうでなければ現在いる節と大きさを比較してその結果から左右どちらかを再帰的に探索して
  (`NULL`のポインタが挿入すべき位置である)
として挿入すべき位置を探索する。

得られた位置に節を挿入する。

#sourcecode[```c
void insert_bst(Node **root, int d) {
  if (root != NULL && *root != NULL) {
    if ((*root)->value == d) {
      return; // nothing to do
    } else if ((*root)->value < d) {
      if ((*root)->right != NULL) {
        insert_bst(&(*root)->right, d);
      } else {
        Node *new = (Node *)malloc(sizeof(Node));
        new->left = NULL;
        new->right = NULL;
        new->value = d;

        (*root)->right = new;
      }
    } else {
      if ((*root)->left != NULL) {
        insert_bst(&(*root)->left, d);
      } else {
        Node *new = (Node *)malloc(sizeof(Node));
        new->left = NULL;
        new->right = NULL;
        new->value = d;

        (*root)->left = new;
      }
    }
  } else if (root != NULL) {
    Node *new = (Node *)malloc(sizeof(Node));
    new->left = NULL;
    new->right = NULL;
    new->value = d;

    *root = new;
  } else {
    fprintf(stderr, "Binary Search Tree NULL pointer dereference!!\n");
    exit(EXIT_FAILURE);
  }
}
```]

=== 節の削除

基本的には教科書 @textbook 76ページ リスト4.6, 77ページ リスト4.7 のアイデアを採用した(`delete_bst_node()`が教科書の`delete_el()`に対応する)。

仕組み上、現在いる節(`n`)だけでなく、親の節の位置(`parent`)と、左右どちらの子が現在いる節か(`lr`)を記録している必要があり、そのように実装した。

`delete_bst_node()`内では発見された削除対象の節について、
+ 削除対象が木全体の葉である場合
  その葉をそのまま解放する。
  (ただし、木全体の根でもある場合、`*root`を`NULL`にする)
+ 削除対象の子が1つである場合
  + 削除対象の子が1つ(左のみ)である場合
  + 削除対象の子が1つ(右のみ)である場合
  いずれも親から見て現在の節が左右どちらであるかと、現在の節の存在する子が左右どちらであるかに気をつけて付け替えを行い、現在の節を解放する。
+ 削除対象の子が2つである場合
  `while`内で現在の節の右部分木の最小値を探索して、その節と現在の節の値を入れ替え、
  その節を再度削除対象とみなして`delete_bst_node()`自身を再帰的に呼び出す

という手順で削除を行う。ロジック的に正しいはずである。

#sourcecode[```c
enum LR { LEFT, RIGHT };

void delete_bst_node(Node **root, Node *parent, Node *n, enum LR lr) {
  if (n->left == NULL && n->right == NULL) {
    // NOTE: 削除対象が木全体の葉である場合
    free(n);

    if (parent != NULL) {
      if (lr == LEFT) {
        parent->left = NULL;
      } else {
        parent->right = NULL;
      }
    } else {
      if (root != NULL) {
        *root = NULL;
      }
    }
  } else if (n->left != NULL && n->right == NULL) {
    // NOTE: 削除対象の子が1つ(左のみ)である場合
    if (lr == LEFT) {
      parent->left = n->left;
      free(n);
    } else {
      parent->right = n->left;
      free(n);
    }
  } else if (n->left == NULL && n->right != NULL) {
    // NOTE: 削除対象の子が1つ(右のみ)である場合
    if (lr == LEFT) {
      parent->left = n->right;
      free(n);
    } else {
      parent->right = n->right;
      free(n);
    }
  } else {
    // NOTE: 削除対象の子が2つである場合
    Node *rparent = n;
    Node *rmin = n->right;
    enum LR rlr = RIGHT;

    while (rmin->left != NULL) {
      rparent = rmin;
      rmin = rmin->left;
      rlr = LEFT;
    }

    int tmp = n->value;
    n->value = rmin->value;
    rmin->value = tmp;

    delete_bst_node(root, rparent, rmin, rlr);
  }
}

void delete_bst(Node **root, int d) {
  if (root != NULL && *root != NULL) {
    Node *parent = NULL;
    Node *n = *root;
    enum LR lr;

    while (n != NULL) {
      if (n->value > d) {
        parent = n;
        lr = LEFT;
        n = n->left;
      } else if (n->value < d) {
        parent = n;
        lr = RIGHT;
        n = n->right;
      } else {
        delete_bst_node(root, parent, n, lr);
        return;
      }
    }
  } else {
    return; // nothing to do
  }
}
```]

=== テスト

`3. 以下の要件を全て満たすことを確認すること.` にしたがいmainを以下のように書き換えてテストを行った(内容はコメントのとおりである)。

#sourcecode[```c
#include "binarysearchtree.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  // Build a binary search tree
  Node *root = NULL;

  // 空である場合の最小値
  printf("min_bst: %d\n", min_bst(root));

  insert_bst(&root, 10);
  insert_bst(&root, 15);
  insert_bst(&root, 18);
  insert_bst(&root, 6);
  insert_bst(&root, 12);
  insert_bst(&root, 20);
  insert_bst(&root, 9);

  inorder(root);
  display(root);

  // 探索されるデータが根にある場合
  printf("search_bst 10: %d\n", search_bst(root, 10));
  // 葉にある場合
  printf("search_bst 12: %d\n", search_bst(root, 12));
  // 根以外の非終端節点にある場合
  printf("search_bst 15: %d\n", search_bst(root, 15));

  // 空でない場合の最小値
  printf("min_bst: %d\n", min_bst(root));

  // 根であり、子が2つともある節点を削除する場合
  delete_bst(&root, 10);

  inorder(root);

  display(root);

  // 子が1つのみの節点を削除する場合
  delete_bst(&root, 18);

  inorder(root);

  display(root);

  // 子がない節点を削除する場合
  delete_bst(&root, 20);

  inorder(root);

  display(root);

  delete_tree(root);

  return EXIT_SUCCESS;
}
```]

以下の出力が得られ正しく動作していることが分かる。

#sourcecode[```bash
$ ./binarysearchtree
min_bst: -1
IN: 6 9 10 12 15 18 20
TREE: 10(6(null,9(null,null)),15(12(null,null),18(null,20(null,null))))
search_bst 10: 1
search_bst 12: 1
search_bst 15: 1
min_bst: 6
IN: 6 9 12 15 18 20
TREE: 12(6(null,9(null,null)),15(null,18(null,20(null,null))))
IN: 6 9 12 15 20
TREE: 12(6(null,9(null,null)),15(null,20(null,null)))
IN: 6 9 12 15
TREE: 12(6(null,9(null,null)),15(null,null))
```]

#bibliography-list(
  title: "参考文献", // 節見出しの文言
)[
#bib-item(<textbook>)[未来へつなぐデジタルシリーズ10 アルゴリズムとデータ構造 共立出版株式会社, https://www.kyoritsu-pub.co.jp/book/b10008170.html, 2025 年 11 月 25 日閲覧]
]
