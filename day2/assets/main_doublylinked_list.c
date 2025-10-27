#include "doublylinked_list.h"
#include <stdlib.h>

int main(void) {
  Cell *head = CreateCell(0, true);
  Cell *elem;

  InsertNext(head, CreateCell(2, false));
  InsertNext(head, CreateCell(1, false));
  InsertPrev(head, CreateCell(5, false));
  Display(head);
  DisplayReverse(head->prev);

  elem = SearchCell(head, 2);
  InsertNext(elem, CreateCell(3, false));
  Display(head);

  elem = SearchCell(head, 5);
  DeleteCell(elem);
  Display(head);

  DeleteCell(head->next);
  DeleteCell(head->prev);
  DeleteCell(head->next);
  Display(head);

  return EXIT_SUCCESS;
}
