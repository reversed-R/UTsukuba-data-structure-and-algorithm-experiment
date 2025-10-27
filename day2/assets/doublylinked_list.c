#include "doublylinked_list.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSIZE 64

Cell *CreateCell(int d, bool is_head) {
  Cell *new = (Cell *)malloc(sizeof(Cell));
  new->is_head = is_head;
  new->data = d;
  new->prev = new;
  new->next = new;

  return new;
}

void InsertNext(Cell *this_cell, Cell *p) {
  if (this_cell != NULL) {
    Cell *next_next = this_cell->next;
    this_cell->next = p;
    p->prev = this_cell;
    p->next = next_next;
    if (next_next != NULL) {
      next_next->prev = p;
    }
  } else {
    fprintf(stderr,
            "invalid operation; cannot insert next NULL Cell pointer\n");
    exit(EXIT_FAILURE);
  }
}

void InsertPrev(Cell *this_cell, Cell *p) {
  if (this_cell != NULL) {
    Cell *prev = this_cell->prev;
    this_cell->prev = p;
    p->next = this_cell;
    p->prev = prev;
    if (prev != NULL) {
      prev->next = p;
    }
  } else {
    fprintf(stderr,
            "invalid operation; cannot insert prev NULL Cell pointer\n");
    exit(EXIT_FAILURE);
  }
}

void DeleteCell(Cell *this_cell) {
  if (this_cell != NULL) {
    if (this_cell->prev != NULL) {
      this_cell->prev->next = this_cell->next;
    }
    if (this_cell->next != NULL) {
      this_cell->next->prev = this_cell->prev;
    }
    free(this_cell);
  }
}

Cell *SearchCell(Cell *this_cell, int d) {
  Cell *p = this_cell;
  do {
    if (p->data == d) {
      return p;
    } else {
      p = p->next;
    }
  } while (p != this_cell);

  return NULL;
}

void Display(Cell *this_cell) {
  Cell *p = this_cell;
  do {
    if (!p->is_head) {
      printf("%d ", p->data);
    }
    p = p->next;
  } while (p != this_cell);

  printf("\n");
}

void DisplayReverse(Cell *this_cell) {
  Cell *p = this_cell;
  do {
    if (!p->is_head) {
      printf("%d ", p->data);
    }
    p = p->prev;
  } while (p != this_cell);

  printf("\n");
}

void ReadFromArray(Cell *this_cell, int *data, unsigned int len) {
  Cell *p = this_cell;
  for (int i = 0; i < len; i++) {
    InsertNext(p, CreateCell(data[i], false));
    p = p->next;
  }
}

void WriteToArray(Cell *this_cell, int *data, unsigned int max_len) {
  Cell *p = this_cell;
  int i = 0;
  do {
    if (i >= max_len) {
      fprintf(stderr, "failed to write to array; array buffer over flowed\n");
      exit(EXIT_FAILURE);
    }
    data[i] = p->data;
    p = p->next;
    i++;
  } while (p != this_cell);
}

void ReadFromFile(Cell *this_cell, const char *filename) {
  FILE *f;
  if ((f = fopen(filename, "r")) == NULL) {
    fprintf(stderr, "failed to open file; filename=%s, errno=%d\n", filename,
            errno);
    exit(EXIT_FAILURE);
  }

  char buffer[BUFSIZE], *res;

  Cell *p = this_cell->next;
  while ((res = fgets(buffer, BUFSIZE, f)) != NULL) {
    errno = 0;
    char *end;
    int n = strtol(buffer, &end, 10);
    if (end == buffer || errno != 0) {
      fprintf(stderr, "failed to read number from file; errno=%d\n", errno);
      exit(EXIT_FAILURE);
    }

    InsertPrev(p, CreateCell(n, false));
  }

  fclose(f);
}

void WriteToFile(Cell *this_cell, const char *filename) {
  FILE *f;
  if ((f = fopen(filename, "w")) == NULL) {
    fprintf(stderr, "failed to open file; filename=%s, errno=%d\n", filename,
            errno);
    exit(EXIT_FAILURE);
  }

  char buffer[BUFSIZE];

  Cell *p = this_cell;
  do {
    snprintf(buffer, BUFSIZE, "%d\n", p->data);
    size_t written = fwrite(buffer, sizeof(char), strlen(buffer), f);
    if (written == 0) {
      fprintf(stderr, "failed to write to file; filename=%s, errno=%d\n",
              filename, errno);
      exit(EXIT_FAILURE);
    }
    p = p->next;
  } while (p != this_cell);

  fflush(f);
  fclose(f);
}
