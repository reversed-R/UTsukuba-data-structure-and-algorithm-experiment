#include "linked_list.h"
#include <stdlib.h>

extern Cell *head;

int main(void) {
  insert_cell_top(1);
  insert_cell(head, 3);
  insert_cell(head, 2);
  display();

  delete_cell(head);
  display();

  delete_cell_top();
  display();

  return EXIT_SUCCESS;
}
