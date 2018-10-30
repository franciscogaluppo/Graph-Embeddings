#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX(i,j) (i < j? j: i)
#define DIST(a,b,x,y) (sqrtf((a-x)*(a-x) + (b-y)*(b-y)))
#define NLEN 70
#define FTS 5
#define N 3000

char nomeGrafo[NLEN] = "scale-free";

int main()
{
    // Cria tabelas para as coordenadas
    double** coords = (double**) malloc(sizeof(double*)*N);
    for(int i = 0; i < N; i++)
        coords[i] = (double*) malloc(sizeof(double)*(FTS));


    // Lê as tabelas
    double a, b, c, d, e;
    char fileName[NLEN];

    sprintf(fileName, "amostras/%s-EMBS.amostra", nomeGrafo);
    FILE* arq = fopen(fileName, "r");

    for(int j = 0; fscanf(arq, "%lf,%lf,%lf,%lf,%lf", &a, &b, &c, &d, &e) != EOF; j++)
    {
        coords[j][0] = a;
        coords[j][1] = b;
        coords[j][2] = c;
        coords[j][3] = d;
        coords[j][4] = e;
    }
    fclose(arq);

    // Calcula distâncias entre pares
    sprintf(fileName, "dists/%s-EMBS.dist", nomeGrafo);
    arq = fopen(fileName, "w");
    fprintf(arq, "d1,d2,sum_degree\n");
    for(int i = 0; i < N; i++)
        for(int j = i; j < N; j++)
            fprintf(
                arq, "%lf,%lf,%d\n",
                DIST(coords[i][3], coords[i][4], coords[j][3], coords[j][4]),
                DIST(coords[i][1], coords[i][2], coords[j][1], coords[j][2]),
                (int) (coords[i][0] + coords[j][0])
            );
    fclose(arq);


    // Libera tabela
    for(int i = 0; i < N; i++)
        free(coords[i]);
    free(coords);
}