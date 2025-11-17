#include "./queue.h"
#include <stdio.h>
#include <stdlib.h>

Queue *create_queue(int len) {
  Queue *p = (Queue *)malloc(sizeof(Queue));
  p->buffer = (void **)malloc(sizeof(void *) * len);
  p->front = 0;
  p->rear = 0;
  p->length = len;

  return p;
}

void enqueue(Queue *q, void *d) {
  if (q != NULL) {
    if (q->rear + 1 == q->length) {
      if (q->front == 0) {
        fprintf(stderr, "Queue overfolwed!!\n");
        exit(EXIT_FAILURE);
      } else {
        q->buffer[q->rear] = d;
        q->rear = 0;
      }
    } else {
      if (q->rear + 1 == q->front) {
        fprintf(stderr, "Queue overfolwed!!\n");
        exit(EXIT_FAILURE);
      } else {
        q->buffer[q->rear] = d;
        q->rear++;
      }
    }
  } else {
    fprintf(stderr, "Queue NULL pointer dereference!!\n");
    exit(EXIT_FAILURE);
  }
}

void *dequeue(Queue *q) {
  if (q != NULL) {
    if (q->rear == q->front) {
      fprintf(stderr, "Queue underfolwed!!\n");
      exit(EXIT_FAILURE);
    } else {
      void *d = q->buffer[q->front];
      if (q->front + 1 == q->length) {
        q->front = 0;
      } else {
        q->front++;
      }
      return d;
    }
  } else {
    fprintf(stderr, "Queue NULL pointer dereference!!\n");
    exit(EXIT_FAILURE);
  }
}

void delete_queue(Queue *q) {
  if (q != NULL) {
    free(q->buffer);
    free(q);
  }
}
