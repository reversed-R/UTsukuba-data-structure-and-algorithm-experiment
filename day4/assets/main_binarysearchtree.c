#include "binarysearchtree.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  // Build a binary search tree
  Node *root = NULL;
  insert_bst(&root, 20);
  insert_bst(&root, 10);
  insert_bst(&root, 26);
  insert_bst(&root, 14);
  insert_bst(&root, 13);
  insert_bst(&root, 5);

  inorder(root);
  display(root);

  printf("search_bst 14: %d\n", search_bst(root, 14));
  printf("search_bst 7: %d\n", search_bst(root, 7));
  printf("min_bst: %d\n", min_bst(root));

  delete_bst(&root, 10);

  inorder(root);

  display(root);

  delete_tree(root);

  return EXIT_SUCCESS;
}
