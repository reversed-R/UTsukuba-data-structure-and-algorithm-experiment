#include "./open_addressing.h"
#include <stdio.h>
#include <stdlib.h>

DictOpenAddr *create_dict(int len) {
  DictOpenAddr *dict = (DictOpenAddr *)malloc(sizeof(DictOpenAddr));
  dict->H = (DictData *)malloc(sizeof(DictData) * len);
  dict->B = len;

  // すべてのデータ領域を空で初期化
  for (int i = 0; i < len; i++) {
    DictData d = dict->H[i];
    d.state = EMPTY;
  }

  return dict;
}

int h(DictOpenAddr *dict, int d, int count) {
  // h0()にh()自身を用いる場合、剰余の等価性の関係により、結局d自身を用いても同じ結果が得られる。
  // これによりh()を再帰呼出しをすることによる計算コストを除去できる。
  return (d + count) % dict->B;
}

void insert_hash(DictOpenAddr *dict, int d) {
  // 安全のため、dictのlen回以上空きスロットを探索した場合は辞書自体のオーバフローとしてエラー終了
  for (int i = 0; i < dict->B; i++) {
    int hash = h(dict, d, i);
    DictData *data = &dict->H[hash];

    switch (data->state) {
    case EMPTY:
    case DELETED:
      data->name = d;
      data->state = OCCUPIED;
      return;
    case OCCUPIED:
      if (data->name == d) {
        return;
      }
      continue;
    }
  }

  fprintf(stderr, "dictionary overflowed!!\n");
  exit(EXIT_FAILURE);
}

int search_hash(DictOpenAddr *dict, int d) {
  for (int i = 0; i < dict->B; i++) {
    int hash = h(dict, d, i);
    DictData *data = &dict->H[hash];
    if (data->name == d && data->state == OCCUPIED) {
      return hash;
    }
  }

  return -1;
}

void delete_hash(DictOpenAddr *dict, int d) {
  for (int i = 0; i < dict->B; i++) {
    int hash = h(dict, d, i);
    DictData *data = &dict->H[hash];
    if (data->name == d && data->state == OCCUPIED) {
      data->state = DELETED;
      return;
    }
  }
}

void display(DictOpenAddr *dict) {
  for (int i = 0; i < dict->B; i++) {
    DictData data = dict->H[i];

    switch (data.state) {
    case EMPTY:
      printf("e ");
      break;
    case OCCUPIED:
      printf("%d ", data.name);
      break;
    case DELETED:
      printf("d ");
      break;
    }
  }

  printf("\n");
}

void delete_dict(DictOpenAddr *dict) {
  if (dict != NULL) {
    free(dict->H);
    free(dict);
  }
}
