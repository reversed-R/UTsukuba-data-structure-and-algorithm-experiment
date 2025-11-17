#include "binarytree.h"
#include "./queue.h"
#include <stdio.h>
#include <stdlib.h>

#define QUEUE_BUFSIZE 1024

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

int height(Node *n) {
  if (n == NULL) {
    return 0;
  } else {
    int lheight = height(n->left);
    int rheight = height(n->right);

    return 1 + (lheight > rheight ? lheight : rheight);
  }
}

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
