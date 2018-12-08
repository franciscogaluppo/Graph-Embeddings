#include <stdio.h>
#include <stdlib.h>
#include "math.h"

// soc-sign-bitcoinotc       353
// wiki-Vote                 1366
// scale-free                260
// email-Enron               3283

#define NLEN 2000
#define DIM 128
#define TAM 7
#define N 1366

int FTS = 2*DIM+2;
int percents[TAM] = {1, 5, 10, 20, 50, 90, 99};
char nomeGrafo[NLEN] = "wiki-Vote";

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
    double*** coords = (double***) malloc(sizeof(double**)*N);
    for(int i = 0; i < N; i++)
    {
        coords[i] = (double**) malloc(sizeof(double*)*(FTS));
        for(int j = 0; j < FTS; j++)
            coords[i][j] = (double*) malloc(sizeof(double)*(TAM));
    }

    // Lê as tabelas
    char fileName[NLEN];
    int num;
    for(int i = 0; i < TAM; i++)
    {
        sprintf(fileName, "amostras/%s-%dd-%d%%rem-%d.amostra", nomeGrafo, DIM, percents[i], N);
        FILE* arq = fopen(fileName, "r");
        
        for(int j = 0; fscanf(arq, "%lf", &coords[j][0][i]) != EOF; j++)
        {
            printf("\n%d ", coords[j][0][i]);
            for(int k = 1; k < FTS; k++)
            {
                fscanf(arq, ",%lf", &coords[j][k][i]);
                printf("%d ", coords[j][k][i]);
            }
        }

        fclose(arq);
    }

    // Calcula distâncias entre pares
    for(int k = 0; k < TAM; k++)
    {
        sprintf(fileName, "dists/%s-%dd-%d%%rem-%d.dist", nomeGrafo, DIM, percents[k], N);
        FILE* arq = fopen(fileName, "w");
        fprintf(arq, "d1,d2,sum_degree,grupo\n");
        for(int i = 0; i < N; i++)
            for(int j = i; j < N; j++)
                if(coords[i][FTS-1][k] == coords[j][FTS-1][k])
                    fprintf(
                        arq, "%lf,%lf,%d,%d\n",
                        dist(&coords[i][1][k], &coords[j][1][k]),
                        dist(&coords[i][1+DIM][k], &coords[j][1+DIM][k]),
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