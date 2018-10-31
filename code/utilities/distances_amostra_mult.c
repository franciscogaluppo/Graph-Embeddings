#include <stdio.h>
#include <stdlib.h>
#include "math.h"

#define NLEN 70
#define DIM 128
#define FTS 1
#define N 3000

int tam = 2*DIM + FTS;
char nomeGrafo[NLEN] = "soc-sign-bitcoinotc";

// Distâncias
double dist(double v[], double u[])
{ 
    double soma = 0;
    for(int i = 0; i < DIM; i++)
        soma += (v[i]-u[i])*(v[i]-u[i]);
    return sqrt(soma);
}

int main()
{
    // Cria tabelas para as coordenadas
    double** coords = (double**) malloc(sizeof(double*)*N);
    for(int i = 0; i < N; i++)
        coords[i] = (double*) malloc(sizeof(double)*(tam));


    // Lê as tabelas
    double a, b, c, d, e;
    char fileName[NLEN];

    sprintf(fileName, "amostras/%s-mult.amostra", nomeGrafo);
    FILE* arq = fopen(fileName, "r");

    for(int i = 0; fscanf(arq, "%lf", &coords[i][0]) != EOF; i++)
    {
        for(int j = 1; j < tam; j++)
            fscanf(arq, ",%lf", &coords[i][j]);
    }

    fclose(arq);

    // Calcula distâncias entre pares
    sprintf(fileName, "dists/%s-mult.dist", nomeGrafo);
    arq = fopen(fileName, "w");
    fprintf(arq, "d1,d2,sum_degree\n");
    for(int i = 0; i < N; i++)
        for(int j = i; j < N; j++)
            fprintf(
                arq, "%lf,%lf,%d\n",
                dist(&coords[i][1], &coords[j][1]),
                dist(&coords[i][1+DIM], &coords[j][1+DIM]),
                (int) (coords[i][0] + coords[j][0])
            );
    fclose(arq);


    // Libera tabela
    for(int i = 0; i < N; i++)
        free(coords[i]);
    free(coords);
}