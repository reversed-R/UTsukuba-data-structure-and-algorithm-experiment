#include "queue.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int i;
  Queue *test_q = create_queue(10);

  enqueue(test_q, 1);
  enqueue(test_q, 2);
  display(test_q);

  printf("%d\n", dequeue(test_q));
  printf("%d\n", dequeue(test_q));

  for (i = 0; i < 8; i++) {
    enqueue(test_q, i);
  }
  for (i = 0; i < 5; i++) {
    dequeue(test_q);
  }
  for (i = 0; i < 5; i++) {
    enqueue(test_q, 10 + i);
  }
  display(test_q);

  delete_queue(test_q);

  return EXIT_SUCCESS;
}
