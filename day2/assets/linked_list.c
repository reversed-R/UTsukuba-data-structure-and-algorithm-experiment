#include "linked_list.h"
#include <stdio.h>
#include <stdlib.h>

Cell *head = NULL;

void insert_cell(Cell *p, int d) {
  if (p != NULL) {
    Cell *new = (Cell *)malloc(sizeof(Cell));
    new->data = d;
    new->next = p->next;
    p->next = new;
  }
}

void insert_cell_top(int d) {
  Cell *new = (Cell *)malloc(sizeof(Cell));
  new->data = d;
  new->next = head;
  head = new;
}

void delete_cell(Cell *p) {
  if (p != NULL) {
    Cell *next_next = NULL;
    if (p->next != NULL) {
      next_next = p->next->next;
    }
    free(p->next);
    p->next = next_next;
  }
}

void delete_cell_top(void) {
  if (head != NULL) {
    Cell *second = head->next;
    free(head);
    head = second;
  }
}

void display(void) {
  Cell *p = head;
  while (p != NULL) {
    printf("%d ", p->data);
    p = p->next;
  }
  printf("\n");
}
