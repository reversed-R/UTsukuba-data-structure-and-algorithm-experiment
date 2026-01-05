#ifndef _COMMON_H_
#define _COMMON_H_

#include <limits.h>

#define N 8
#define M INT_MAX

static int const w[N][N] = {
    // グラフ1
    {0, M, M, 29, M, M, M, 11},
    {M, 0, M, 3, M, M, M, 12},
    {M, M, 0, M, M, 9, M, M},
    {M, 13, M, 0, M, M, M, M},
    {M, M, M, M, 0, M, M, 21},
    {M, M, 19, 22, M, 0, 9, M},
    {M, M, M, M, M, M, 0, 29},
    {M, 11, M, 22, 28, 12, M, 0}
    // グラフ2
    /*
    {0, M, 9, 29, M, M, M, 4},
    {28, 0, M, M, 14, M, M, M},
    {M, 2, 0, M, 27, M, M, M},
    {M, M, M, 0, M, M, M, M},
    {M, M, M, M, 0, M, 6, 25},
    {M, 4, 23, M, M, 0, 19, M},
    {M, M, M, 3, 25, M, 0, M},
    {M, M, M, M, 21, 26, 17, 0}
    */
};

#endif
