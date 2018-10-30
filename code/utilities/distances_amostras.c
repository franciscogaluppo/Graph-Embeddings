#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* Regular sizes */
// soc-sign-bitcoinotc       358
// wiki-Vote                 1050
// scale-free                281
// email-Enron               3344

/* GCC sizes */
// soc-sign-bitcoinotc       358
// wiki-Vote                 1046
// email-Enron               3264

#define MAX(i,j) (i < j? j: i)
#define DIST(a,b,x,y) (sqrtf((a-x)*(a-x) + (b-y)*(b-y)))
#define NLEN 70
#define TAM 7
#define FTS 6
#define N 3264

int percents[TAM] = {1, 5, 10, 20, 50, 90, 99};
char nomeGrafo[NLEN] = "email-Enron";

int main()
{
    // Cria tabelas para as coordenadas
    double*** coords = (double***) malloc(sizeof(double**)*N);
    for(int i = 0; i < N; i++)
    {

        coords[i] = (double**) malloc(sizeof(double*)*(FTS));
        for(int j = 0; j < FTS; j++)
            coords[i][j] = (double*) malloc(sizeof(double)*(TAM));
    }


    // Lê as tabelas
    double a, b, c, d, e, f;
    char fileName[NLEN];
    for(int i = 0; i < TAM; i++)
    {
        sprintf(fileName, "amostras/%s-GCC-%d%%rem-%d.amostra", nomeGrafo, percents[i], N);
        FILE* arq = fopen(fileName, "r");

        for(int j = 0; fscanf(arq, "%lf,%lf,%lf,%lf,%lf,%lf", &a, &b, &c, &d, &e, &f) != EOF; j++)
        {
            coords[j][0][i] = a;
            coords[j][1][i] = b;
            coords[j][2][i] = c;
            coords[j][3][i] = d;
            coords[j][4][i] = e;
            coords[j][5][i] = f;
        }

        fclose(arq);
    }


    // Calcula distâncias entre pares
    for(int k = 0; k < TAM; k++)
    {
        sprintf(fileName, "dists/%s-GCC-2d-%d%%rem-%d.dist", nomeGrafo, percents[k], N);
        FILE* arq = fopen(fileName, "w");
        fprintf(arq, "d1,d2,sum_degree,grupo\n");
        for(int i = 0; i < N; i++)
            for(int j = i; j < N; j++)
                if(coords[i][FTS-1][k] == coords[j][FTS-1][k])
                    fprintf(
                        arq, "%lf,%lf,%d,%d\n",
                        DIST(coords[i][3][k], coords[i][4][k], coords[j][3][k], coords[j][4][k]),
                        DIST(coords[i][1][k], coords[i][2][k], coords[j][1][k], coords[j][2][k]),
                        (int) (coords[i][0][k] + coords[j][0][k]),
                        (int) coords[i][FTS-1][k]
                    );
        fclose(arq);
    }

    // Libera tabela
    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < FTS; j++)
            free(coords[i][j]);
        free(coords[i]);
    }
    free(coords);
}