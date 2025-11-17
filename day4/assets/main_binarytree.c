#include "binarytree.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  // Build a binary tree
  Node *f = create_node("F", NULL, NULL);
  Node *i = create_node("I", NULL, NULL);
  Node *d = create_node("D", f, NULL);
  Node *g = create_node("G", NULL, NULL);
  Node *a = create_node("A", i, d);
  Node *l = create_node("L", NULL, g);
  Node *c = create_node("C", a, l);

  preorder(c);
  inorder(c);
  postorder(c);
  breadth_first_search(c);
  display(c);

  printf("height: %d\n", height(c));

  delete_tree(c);

  return EXIT_SUCCESS;
}
