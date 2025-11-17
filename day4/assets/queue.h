#ifndef INCLUDE_GUARD_QUEUE_H
#define INCLUDE_GUARD_QUEUE_H

typedef struct queue {
  void **buffer;
  int length;
  int front;
  int rear;
} Queue;

Queue *create_queue(int len);
void enqueue(Queue *q, void *d);
void *dequeue(Queue *q);
void delete_queue(Queue *q);

#endif // INCLUDE_GUARD_QUEUE_H
