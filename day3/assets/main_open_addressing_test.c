#include "open_addressing.h"
#include <stdlib.h>

int main(void) {
  DictOpenAddr *test_dict = create_dict(10);

  for (int i = 0; i < 11; i++) {
    insert_hash(test_dict, i * 10 + 3);

    display(test_dict);
  }

  delete_dict(test_dict);

  return EXIT_SUCCESS;
}
