#include "./queue.h"
#include <stdio.h>
#include <stdlib.h>

Queue *create_queue(int len) {
  Queue *p = (Queue *)malloc(sizeof(Queue));
  p->buffer = (int *)malloc(sizeof(int) * len);
  p->front = 0;
  p->rear = 0;
  p->length = len;

  return p;
}

void enqueue(Queue *q, int d) {
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

int dequeue(Queue *q) {
  if (q != NULL) {
    if (q->rear == q->front) {
      fprintf(stderr, "Queue underfolwed!!\n");
      exit(EXIT_FAILURE);
    } else {
      int d = q->buffer[q->front];
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

void display(Queue *q) {
  if (q != NULL) {
    int i = q->front;
    while (i != q->rear) {
      printf("%d ", q->buffer[i]);
      if (i + 1 == q->length) {
        i = 0;
      } else {
        i++;
      }
    }
    printf("\n");
  }
}

void delete_queue(Queue *q) {
  if (q != NULL) {
    free(q->buffer);
    free(q);
  }
}
