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

  /* Node *root = NULL; */
  /* insert_bst(&root, 20); */
  /* insert_bst(&root, 10); */
  /* insert_bst(&root, 26); */
  /* insert_bst(&root, 14); */
  /* insert_bst(&root, 13); */
  /* insert_bst(&root, 5); */
  /**/
  /* inorder(root); */
  /* display(root); */
  /**/
  /* printf("search_bst 14: %d\n", search_bst(root, 14)); */
  /* printf("search_bst 7: %d\n", search_bst(root, 7)); */
  /* printf("min_bst: %d\n", min_bst(root)); */
  /**/
  /* delete_bst(&root, 10); */
  /**/
  /* inorder(root); */
  /**/
  /* display(root); */
  /**/
  /* delete_tree(root); */

  return EXIT_SUCCESS;
}
