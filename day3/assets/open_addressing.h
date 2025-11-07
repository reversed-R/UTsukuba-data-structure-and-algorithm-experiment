#ifndef INCLUDE_GUARD_OPEN_ADDRESSING_H
#define INCLUDE_GUARD_OPEN_ADDRESSING_H

typedef enum state { EMPTY, DELETED, OCCUPIED } State;

typedef struct dict_data {
  int name;
  State state;
} DictData;

typedef struct dict_open_addr {
  DictData *H;
  int B;
} DictOpenAddr;

DictOpenAddr *create_dict(int len);
int h(DictOpenAddr *dict, int d, int count);
void insert_hash(DictOpenAddr *dict, int d);
int search_hash(DictOpenAddr *dict, int d);
void delete_hash(DictOpenAddr *dict, int d);
void display(DictOpenAddr *dict);
void delete_dict(DictOpenAddr *dict);

#endif // INCLUDE_GUARD_OPEN_ADDRESSING_H
