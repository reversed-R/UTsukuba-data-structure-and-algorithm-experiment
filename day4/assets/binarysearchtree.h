#ifndef INCLUDE_GUARD_BINARYSEARCHTREE_H
#define INCLUDE_GUARD_BINARYSEARCHTREE_H

#include <stdbool.h>

typedef struct node {
  int value;
  struct node *left;
  struct node *right;
} Node;

// binarysearchtree-specific functions
int min_bst(Node *root);
bool search_bst(Node *root, int d);
void insert_bst(Node **root, int d);
void delete_bst(Node **root, int d);

// Reuse the following functions implemented for the binarytree
void inorder(Node *root);
void display(Node *root);
void delete_tree(Node *root);

#endif // INCLUDE_GUARD_BINARYSEARCHTREE_H
