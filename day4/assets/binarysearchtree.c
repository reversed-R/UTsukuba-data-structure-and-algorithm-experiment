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
    fprintf(stderr, "Queue NULL pointer dereference!!\n");
    exit(EXIT_FAILURE);
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
    if ((*root)->value < d) {
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
    fprintf(stderr, "Queue NULL pointer dereference!!\n");
    exit(EXIT_FAILURE);
  }
}

void search_bst_parent(Node **parent, Node **found, int d) {
  if (parent != NULL && *parent != NULL) {
    if ((*parent)->value == d) {
      *found = *parent;
      *parent = NULL;
      return;
    }

    if ((*parent)->left != NULL && (*parent)->left->value == d) {
      *found = (*parent)->left;
    } else if ((*parent)->right != NULL && (*parent)->right->value == d) {
      *found = (*parent)->right;
    } else if ((*parent)->value > d) {
      *parent = (*parent)->left;
      search_bst_parent(parent, found, d);
    } else {
      *parent = (*parent)->right;
      search_bst_parent(parent, found, d);
    }
  } else {
    parent = NULL;
    found = NULL;
  }
}

/* Node *search_bst_ptr(Node *root, int d) { */
/*   if (root != NULL) { */
/*     if (root->value == d) { */
/*       return root; */
/*     } else if (root->value < d) { */
/*       return search_bst_ptr(root->right, d); */
/*     } else { */
/*       return search_bst_ptr(root->left, d); */
/*     } */
/*   } else { */
/*     return NULL; */
/*   } */
/* } */

Node *min_bst_ptr(Node *n) {
  if (n != NULL) {
    Node *sub = min_bst_ptr(n->left);

    if (sub != NULL) {
      return sub;
    } else {
      return n;
    }
  } else {
    return NULL;
  }
}

enum LR { LEFT, RIGHT };

void delete_bst_node(Node **root, Node *parent, Node *n, enum LR lr) {
  printf("delete_bst_node\n");

  if (n->left == NULL && n->right == NULL) {
    // NOTE: 削除対象が木全体の葉である場合

    printf(" delete_bst_node frees leaf: %d, ptr: %p\n", n->value, n);

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

    printf(" delete_bst_node frees node: %d, left child: %d, ptr: %p\n",
           n->value, n->left->value, n);

    if (lr == LEFT) {
      parent->left = n->left;
      free(n);
    } else {
      parent->right = n->left;
      free(n);
    }
  } else if (n->left == NULL && n->right != NULL) {
    // NOTE: 削除対象の子が1つ(右のみ)である場合

    printf(" delete_bst_node frees node: %d, right child: %d, ptr: %p\n",
           n->value, n->right->value, n);

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

    printf(" delete_bst_node swaps (n->value: %d) and (rmin->value: %d)\n",
           n->value, rmin->value);
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
        /* if (n->left == NULL || n->right == NULL) { */
        /*   // NOTE: 削除対象の節の子が1つ以下の場合 */
        /*   delete_subtree(parent, n, lr); */
        /* } else { */
        /*   // NOTE: 削除対象の節の子が2つの場合 */
        /*   Node *rparent = NULL; */
        /*   Node *rmin = n->right; */
        /*   enum LR rlr = RIGHT; */
        /**/
        /*   while (rmin->left != NULL) { */
        /*     rparent = rmin; */
        /*     rmin = rmin->left; */
        /*     rlr = LEFT; */
        /*   } */
        /**/
        /*   n->value = rmin->value; */
        /*   rmin->value = d; */
        /**/
        /*   delete_subtree(rparent, rmin, rlr); */
        /* } */
      }
    }
  } else {
    return; // nothing to do
  }
}

/* void delete_bst(Node **root, int d) { */
/*   if (root != NULL && *root != NULL) { */
/*     Node *n = NULL; */
/*     Node *found = NULL; */
/*     search_bst_parent(&n, &found, d); */
/**/
/*     if (n != NULL && found != NULL) { */
/*       // NOTE: 木の根でない通常の節が削除対象だった場合 */
/*       if (found->left != NULL && found->right != NULL) { */
/**/
/*       } else if (found->left != NULL && found->right == NULL) { */
/*         // NOTE: 削除対象の節に子が1つのみいる場合 */
/*         free(found); */
/**/
/*         if (found->left != NULL) { */
/*           found = found->left; */
/*         } else { */
/*           found = found->right; */
/*         } */
/*       } else if (found->left == NULL && found->right != NULL) { */
/*         // NOTE: 削除対象の節に子が1つのみいる場合 */
/*         Node *child; */
/*         if (found->left != NULL) { */
/**/
/*           child = found->left; */
/*         } else { */
/*           child = found->right; */
/*         } */
/**/
/*         free(found); */
/**/
/*       } else { */
/**/
/*         free(found); */
/*       } */
/*     } else if (n == NULL && found != NULL) { */
/*       // NOTE: 木全体の根が削除対象だった場合 */
/*     } */
/**/
/*     if (n != NULL) { */
/*       if (n->left == NULL && n->right == NULL) { */
/*         free(n); */
/*       } else if (n->left != NULL && n->right == NULL) { */
/*       } */
/*     } else { */
/*       return; */
/*     } */
/*   } else { */
/*     return; // nothing to do */
/*   } */
/* } */

// NOTE: 通りがけ順で出力する本体
void inorder_subtree(Node *n) {
  printf("inorder_subtree() called\n");
  if (n != NULL) {
    inorder_subtree(n->left);
    printf("%d ", n->value);
    inorder_subtree(n->right);
  } else {
    printf("NULL ");
  }
}

// Reuse the following functions implemented for the binarytree
// NOTE:
// 通りがけ順での出力を与えられたノードから呼び出すだけ。
void inorder(Node *root) {
  printf("inorder called\n");
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
