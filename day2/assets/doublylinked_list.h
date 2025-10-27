#ifndef INCLUDE_GUARD_DOUBLYLINKED_LIST_H
#define INCLUDE_GUARD_DOUBLYLINKED_LIST_H

#include <stdbool.h>

typedef struct cell {
  int data;
  bool is_head;
  struct cell *prev;
  struct cell *next;
} Cell;

Cell *CreateCell(int d, bool is_head);
void InsertNext(Cell *this_cell, Cell *p);
void InsertPrev(Cell *this_cell, Cell *p);
void DeleteCell(Cell *this_cell);
Cell *SearchCell(Cell *this_cell, int d);
void Display(Cell *this_cell);
void DisplayReverse(Cell *this_cell);

void ReadFromArray(Cell *this_cell, int *data, unsigned int len);
void WriteToArray(Cell *this_cell, int *data, unsigned int max_len);
void ReadFromFile(Cell *this_cell, const char *filename);
void WriteToFile(Cell *this_cell, const char *filename);

#endif // INCLUDE_GUARD_DOUBLYLINKED_LIST_H
