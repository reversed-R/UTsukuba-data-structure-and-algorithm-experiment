#include "open_addressing.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  DictOpenAddr *test_dict = create_dict(10);

  insert_hash(test_dict, 1);
  insert_hash(test_dict, 2);
  insert_hash(test_dict, 3);
  insert_hash(test_dict, 11);
  insert_hash(test_dict, 12);
  insert_hash(test_dict, 21);
  display(test_dict);

  printf("Search 1 ...\t%d\n", search_hash(test_dict, 1));
  printf("Search 2 ...\t%d\n", search_hash(test_dict, 2));
  printf("Search 21 ...\t%d\n", search_hash(test_dict, 21));
  printf("Search 5 ...\t%d\n", search_hash(test_dict, 5));

  delete_hash(test_dict, 3);
  display(test_dict);

  delete_hash(test_dict, 11);
  display(test_dict);

  delete_dict(test_dict);

  return EXIT_SUCCESS;
}
