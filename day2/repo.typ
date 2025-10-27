#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.2": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/showybox:2.0.4": showybox
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "課題2",
  subtitle: "連結リスト，スタック，キュー",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "2025 年 10 月 20 日",
)

== 基本課題

=== 2-1

`linked_list`の実装について
基本的に必要な操作は
- セルの追加(特定のセルの後ろにセルを追加する、など)
- セルの削除(特定のセルを削除する、など)
- リスト全体の走査
くらいなもので、それぞれ対応する関数を要件通り書いた。

- セルの追加(特定のセルの後ろにセルを追加する、など)
#sourcecode[```c
void insert_cell(Cell *p, int d) {
  if (p != NULL) {
    Cell *new = (Cell *)malloc(sizeof(Cell));
    new->data = d;
    new->next = p->next;
    p->next = new;
  }
}
```]
コードのとおりだが、指定したセル(前のセル)が指している次のセルを新たなセルの次のセルにし、前のセルの次のセルは新たに作ったセル自身にする、という操作が重要。

- セルの削除(特定のセルを削除する、など)
#sourcecode[```c
void delete_cell(Cell *p) {
  if (p != NULL) {
    Cell *next_next = NULL;
    if (p->next != NULL) {
      next_next = p->next->next;
    }
    free(p->next);
    p->next = next_next;
  }
}

void delete_cell_top(void) {
  if (head != NULL) {
    Cell *second = head->next;
    free(head);
    head = second;
  }
}
```]
これも重要なのは、指定したセルの次のセルや先頭のセルを削除するため、削除されるセルが指している更に次のセルを元のセルに付け替える、という操作である。

- リスト全体の走査
#sourcecode[```c
void display(void) {
  Cell *p = head;
  while (p != NULL) {
    printf("%d ", p->data);
    p = p->next;
  }
  printf("\n");
}
```]
先頭のセルから順に`NULL`でない限りプリントし次のセルに進むと言うだけである。
C的には`while (!p)`とも書けるが可読性を損なうのでこう書いた。

=== 2-2

要件通り関数を書いた。

- キューの作成
#sourcecode[```c
Queue *create_queue(int len) {
  Queue *p = (Queue *)malloc(sizeof(Queue));
  p->buffer = (int *)malloc(sizeof(int) * len);
  p->front = 0;
  p->rear = 0;
  p->length = len;

  return p;
}
```]
キューを作成するだけ。
キュー構造体自身だけでなく、引数で渡された分のバッファ(配列として実現)を動的に確保しているので`free()`する際に注意。

- エンキュー
#sourcecode[```c
void enqueue(Queue *q, int d) {
  if (q != NULL) {
    if (q->rear + 1 == q->length) {
      if (q->front == 0) {
        fprintf(stderr, "Queue overfolwed!!\n");
        exit(EXIT_FAILURE);
      } else {
        q->buffer[q->rear] = d;
        q->rear = 0;
      }
    } else {
      if (q->rear + 1 == q->front) {
        fprintf(stderr, "Queue overfolwed!!\n");
        exit(EXIT_FAILURE);
      } else {
        q->buffer[q->rear] = d;
        q->rear++;
      }
    }
  } else {
    fprintf(stderr, "Queue NULL pointer dereference!!\n");
    exit(EXIT_FAILURE);
  }
}
```]
今のリアの位置に値を格納しリアを後ろにずらすだけで簡単かと思いきや各種境界チェックがあるのでそう簡単ではない。
まずリアがバッファの終端にいるときはその後ろではなく先頭に気を配らなければならない。
どちらの場合もリアの論理的に次に当たる位置にフロントがあるならオーバーフローとなる。

- デキュー
#sourcecode[```c
int dequeue(Queue *q) {
  if (q != NULL) {
    if (q->rear == q->front) {
      fprintf(stderr, "Queue underfolwed!!\n");
      exit(EXIT_FAILURE);
    } else {
      int d = q->buffer[q->front];
      if (q->front + 1 == q->length) {
        q->front = 0;
      } else {
        q->front++;
      }
      return d;
    }
  } else {
    fprintf(stderr, "Queue NULL pointer dereference!!\n");
    exit(EXIT_FAILURE);
  }
}
```]
リアとフロントが同じ位置を指しているときは値が入っていないわけだからアンダーフローになる。
そうでなければフロントの位置から値を取り出し、フロントを次に進めるが、ここでバッファの終端にフロントがいれば回り込んで先頭に戻るという分岐さえすればよい。

- キューの捜査
#sourcecode[```c
void display(Queue *q) {
  if (q != NULL) {
    int i = q->front;
    while (i != q->rear) {
      printf("%d ", q->buffer[i]);
      if (i + 1 == q->length) {
        i = 0;
      } else {
        i++;
      }
    }
    printf("\n");
  }
}
```]
リアからフロントまでインデックスを進めながらプリントしていく。
やはりバッファの終端に来たら回り込んで先頭に移動するということさえやればよい。

- キューの削除
#sourcecode[```c
void delete_queue(Queue *q) {
  if (q != NULL) {
    free(q->buffer);
    free(q);
  }
}
```]
キューの作成時にバッファも動的に確保したのだからそれも`free()`してやる必要がある。
でないとメモリリークしてしまうわけで、やっぱりメモリ管理って人類には難しいと思う。

== 発展課題

=== 2-3

#sourcecode[```c
#include "doublylinked_list.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSIZE 64

Cell *CreateCell(int d, bool is_head) {
  Cell *new = (Cell *)malloc(sizeof(Cell));
  new->is_head = is_head;
  new->data = d;
  new->prev = new;
  new->next = new;

  return new;
}

void InsertNext(Cell *this_cell, Cell *p) {
  if (this_cell != NULL) {
    Cell *next_next = this_cell->next;
    this_cell->next = p;
    p->prev = this_cell;
    p->next = next_next;
    if (next_next != NULL) {
      next_next->prev = p;
    }
  } else {
    fprintf(stderr,
            "invalid operation; cannot insert next NULL Cell pointer\n");
    exit(EXIT_FAILURE);
  }
}

void InsertPrev(Cell *this_cell, Cell *p) {
  if (this_cell != NULL) {
    Cell *prev = this_cell->prev;
    this_cell->prev = p;
    p->next = this_cell;
    p->prev = prev;
    if (prev != NULL) {
      prev->next = p;
    }
  } else {
    fprintf(stderr,
            "invalid operation; cannot insert prev NULL Cell pointer\n");
    exit(EXIT_FAILURE);
  }
}

void DeleteCell(Cell *this_cell) {
  if (this_cell != NULL) {
    if (this_cell->prev != NULL) {
      this_cell->prev->next = this_cell->next;
    }
    if (this_cell->next != NULL) {
      this_cell->next->prev = this_cell->prev;
    }
    free(this_cell);
  }
}

Cell *SearchCell(Cell *this_cell, int d) {
  Cell *p = this_cell;
  do {
    if (p->data == d) {
      return p;
    } else {
      p = p->next;
    }
  } while (p != this_cell);

  return NULL;
}

void Display(Cell *this_cell) {
  Cell *p = this_cell;
  do {
    if (!p->is_head) {
      printf("%d ", p->data);
    }
    p = p->next;
  } while (p != this_cell);

  printf("\n");
}

void DisplayReverse(Cell *this_cell) {
  Cell *p = this_cell;
  do {
    if (!p->is_head) {
      printf("%d ", p->data);
    }
    p = p->prev;
  } while (p != this_cell);

  printf("\n");
}

void ReadFromArray(Cell *this_cell, int *data, unsigned int len) {
  Cell *p = this_cell;
  for (int i = 0; i < len; i++) {
    InsertNext(p, CreateCell(data[i], false));
    p = p->next;
  }
}

void WriteToArray(Cell *this_cell, int *data, unsigned int max_len) {
  Cell *p = this_cell;
  int i = 0;
  do {
    if (i >= max_len) {
      fprintf(stderr, "failed to write to array; array buffer over flowed\n");
      exit(EXIT_FAILURE);
    }
    data[i] = p->data;
    p = p->next;
    i++;
  } while (p != this_cell);
}

void ReadFromFile(Cell *this_cell, const char *filename) {
  FILE *f;
  if ((f = fopen(filename, "r")) == NULL) {
    fprintf(stderr, "failed to open file; filename=%s, errno=%d\n", filename,
            errno);
    exit(EXIT_FAILURE);
  }

  char buffer[BUFSIZE], *res;

  Cell *p = this_cell->next;
  while ((res = fgets(buffer, BUFSIZE, f)) != NULL) {
    errno = 0;
    char *end;
    int n = strtol(buffer, &end, 10);
    if (end == buffer || errno != 0) {
      fprintf(stderr, "failed to read number from file; errno=%d\n", errno);
      exit(EXIT_FAILURE);
    }

    InsertPrev(p, CreateCell(n, false));
  }

  fclose(f);
}

void WriteToFile(Cell *this_cell, const char *filename) {
  FILE *f;
  if ((f = fopen(filename, "w")) == NULL) {
    fprintf(stderr, "failed to open file; filename=%s, errno=%d\n", filename,
            errno);
    exit(EXIT_FAILURE);
  }

  char buffer[BUFSIZE];

  Cell *p = this_cell;
  do {
    snprintf(buffer, BUFSIZE, "%d\n", p->data);
    size_t written = fwrite(buffer, sizeof(char), strlen(buffer), f);
    if (written == 0) {
      fprintf(stderr, "failed to write to file; filename=%s, errno=%d\n",
              filename, errno);
      exit(EXIT_FAILURE);
    }
    p = p->next;
  } while (p != this_cell);

  fflush(f);
  fclose(f);
}
```]

双方向にセルが存在するので、挿入時や削除時に計4箇所のポインタを正しく書き換えることに注意した。
`CreateCell()`で自身のみで1つの双方向循環リストが成立している状態のセルを作らないとそれ以降追加していった際に上手く円形にならないのは注意が必要である。
配列との入出力やファイル入出力も、順に要素を読み取ってセルを増やしていったり逆にセルを順に手繰っていって書き出したりするだけである。


// #bibliography-list(
//   title: "参考文献", // 節見出しの文言
// )[
// #bib-item(<euclid-calc-order>)["", http://example.com, 2025 年 10 月 15 日閲覧]
// ]
