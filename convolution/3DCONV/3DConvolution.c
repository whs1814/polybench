#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#define NI 256
#define NJ 256
#define NK 256
typedef float DATA_TYPE;
double rtclock()
{
    struct timezone Tzp;
    struct timeval Tp;
    int stat;
    stat = gettimeofday (&Tp, &Tzp);
    if (stat != 0) printf("Error return from gettimeofday: %d",stat);
    return(Tp.tv_sec + Tp.tv_usec*1.0e-6);
}
void conv3D(DATA_TYPE* A, DATA_TYPE* B)
{
        int i, j, k;
        DATA_TYPE c11, c12, c13, c21, c22, c23, c31, c32, c33;

        c11 = +2;  c21 = +5;  c31 = -8;
        c12 = -3;  c22 = +6;  c32 = -9;
        c13 = +4;  c23 = +7;  c33 = +10;
#pragma scop
        for (i = 1; i < NI - 1; ++i) // 0
        {
                for (j = 1; j < NJ - 1; ++j) // 1
                {
                        for (k = 1; k < NK -1; ++k) // 2
                           {
 B[i*(NK * NJ) + j*NK + k] = c11 * A[(i - 1)*(NK * NJ) + (j - 1)*NK + (k - 1)]  +  c13 * A[(i + 1)*(NK * NJ) + (j - 1)*NK + (k - 1)]
                                             +   c21 * A[(i - 1)*(NK * NJ) + (j - 1)*NK + (k - 1)]  +  c23 * A[(i + 1)*(NK * NJ) + (j - 1)*NK + (k - 1)]
                                             +   c31 * A[(i - 1)*(NK * NJ) + (j - 1)*NK + (k - 1)]  +  c33 * A[(i + 1)*(NK * NJ) + (j - 1)*NK + (k - 1)]
                                             +   c12 * A[(i + 0)*(NK * NJ) + (j - 1)*NK + (k + 0)]  +  c22 * A[(i + 0)*(NK * NJ) + (j + 0)*NK + (k + 0)]
                                             +   c32 * A[(i + 0)*(NK * NJ) + (j + 1)*NK + (k + 0)]  +  c11 * A[(i - 1)*(NK * NJ) + (j - 1)*NK + (k + 1)]
                                             +   c13 * A[(i + 1)*(NK * NJ) + (j - 1)*NK + (k + 1)]  +  c21 * A[(i - 1)*(NK * NJ) + (j + 0)*NK + (k + 1)]
                                             +   c23 * A[(i + 1)*(NK * NJ) + (j + 0)*NK + (k + 1)]  +  c31 * A[(i - 1)*(NK * NJ) + (j + 1)*NK + (k + 1)]
                                             +   c33 * A[(i + 1)*(NK * NJ) + (j + 1)*NK + (k + 1)];
                        }
                }
        }
#pragma endscop
}

void init(DATA_TYPE* A)
{
        int i, j, k;

        for (i = 0; i < NI; ++i)
        {
                for (j = 0; j < NJ; ++j)
                {
                        for (k = 0; k < NK; ++k)
                        {
                                A[i*(NK * NJ) + j*NK + k] = i % 12 + 2 * (j % 7) + 3 * (k % 13);
                        }
                }
        }
}
int main(int argc, char *argv[])
{

        int i,j,k;
        DATA_TYPE* A;
        DATA_TYPE* B;

        A = (DATA_TYPE*)malloc(NI*NJ*NK*sizeof(DATA_TYPE));
        B = (DATA_TYPE*)malloc(NI*NJ*NK*sizeof(DATA_TYPE));

        init(A);

        conv3D(A, B);
  for (i = 1; i < NI - 1; ++i)
                for (j = 1; j < NJ - 1; ++j)
                      for (k = 1; k < NK - 1; ++k)
       printf("%0.6f\n",B[i*(NK * NJ) + j*NK + k]);
        free(A);
        free(B);

        return 0;
}

