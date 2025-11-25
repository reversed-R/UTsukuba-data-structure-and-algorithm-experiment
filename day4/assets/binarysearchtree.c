#include "binarysearchtree.h"
#include <stdio.h>
#include <stdlib.h>

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

// NOTE: 通りがけ順で出力する本体
void inorder_subtree(Node *n) {
  if (n != NULL) {
    inorder_subtree(n->left);
    printf("%d ", n->value);
    inorder_subtree(n->right);
  }
}

// Reuse the following functions implemented for the binarytree
// NOTE:
// 通りがけ順での出力を与えられたノードから呼び出すだけ。
void inorder(Node *root) {
  printf("IN: ");
  inorder_subtree(root);
  printf("\n");
}

// NOTE:
// 最後(のみ?)に改行を入れるという要件のせいでdisplay_subtree()を作らなければならなくなった。
// Cなので仕方ないのだが、sprintf()などであふれるかもしれないバッファに文字列を結合するよりは、いちいち標準出力に出したほうが安全なので、
// このダサいprintf()まみれになった。
void display_subtree(Node *n) {
  if (n != NULL) {
    printf("%d(", n->value);
    display_subtree(n->left);
    printf(",");
    display_subtree(n->right);
    printf(")");
  } else {
    printf("null");
  }
}

void display(Node *root) {
  printf("TREE: ");
  display_subtree(root);
  printf("\n");
}

void delete_tree(Node *root) {
  if (root != NULL) {
    delete_tree(root->left);
    delete_tree(root->right);

    free(root);
  }
}
