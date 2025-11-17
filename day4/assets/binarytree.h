#ifndef INCLUDE_GUARD_BINARYTREE_H
#define INCLUDE_GUARD_BINARYTREE_H

typedef struct node {
  char *label;
  struct node *left;
  struct node *right;
} Node;

Node *create_node(char *label, Node *left, Node *right);
void preorder(Node *n);
void inorder(Node *n);
void postorder(Node *n);
void display(Node *n);
void breadth_first_search(Node *n);
int height(Node *n);
void delete_tree(Node *n);

#endif // INCLUDE_GUARD_BINARYTREE_H
