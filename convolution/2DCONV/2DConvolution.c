#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

/* Include polybench common header. */
#include <polybench.h>


/* Problem size */
#define NI 4096
#define NJ 4096

typedef float DATA_TYPE;

void conv2D(DATA_TYPE* A, DATA_TYPE* B)
{
        int i, j;
        DATA_TYPE c11, c12, c13, c21, c22, c23, c31, c32, c33;

        c11 = +0.2;  c21 = +0.5;  c31 = -0.8;
        c12 = -0.3;  c22 = +0.6;  c32 = -0.9;
        c13 = +0.4;  c23 = +0.7;  c33 = +0.10;

#pragma scop
        for (i = 1; i < NI - 1; ++i) // 0
        {
                for (j = 1; j < NJ - 1; ++j) // 1
                {
                        B[i*NJ + j] = c11 * A[(i - 1)*NJ + (j - 1)]  +  c12 * A[(i + 0)*NJ + (j - 1)]  +  c13 * A[(i + 1)*NJ + (j - 1)]
                                + c21 * A[(i - 1)*NJ + (j + 0)]  +  c22 * A[(i + 0)*NJ + (j + 0)]  +  c23 * A[(i + 1)*NJ + (j + 0)]
                                + c31 * A[(i - 1)*NJ + (j + 1)]  +  c32 * A[(i + 0)*NJ + (j + 1)]  +  c33 * A[(i + 1)*NJ + (j + 1)];
                }
        }
#pragma endscop
}
void init(DATA_TYPE* A)
{
        int i, j;

        for (i = 0; i < NI; ++i)
        {
                for (j = 0; j < NJ; ++j)
                {
                        A[i*NJ + j] = (float)rand()/RAND_MAX;
                }
        }
}
int main(int argc, char *argv[])
{
  int i, j;
  DATA_TYPE* A;
  DATA_TYPE* B;
  A = (DATA_TYPE*)malloc(NI*NJ*sizeof(DATA_TYPE));
  B = (DATA_TYPE*)malloc(NI*NJ*sizeof(DATA_TYPE));
  //initialize the arrays
  init(A);

  /* Start timer. */
  polybench_start_instruments;

        conv2D(A, B);
//for (i = 1; i < NI - 1; ++i) // 0
//              for (j = 1; j < NJ - 1; ++j) // 1
//printf("%0.6f\n", B[i*NJ + j]);
  /* Stop and print timer. */
  polybench_stop_instruments;
  polybench_print_instruments;

        free(A);
        free(B);

        return 0;
}


