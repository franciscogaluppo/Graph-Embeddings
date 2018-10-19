#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX(i,j) (i < j? j: i)
#define DIST(a,b,x,y) (sqrtf((a-x)*(a-x) + (b-y)*(b-y)))
#define N 7116
#define TAM 7
#define NLEN 70
#define DIM 2

// Tamanhos:
//      soc-sign-bitcoinotc     5881
//      wiki-Vote               7115
//      scale-free              10000
//      email-enron             36692


// FIXME: remover arestas de 1% pode não deixar ninguém isolado

int percents[TAM] = {1, 5, 10, 20, 50, 90, 99};
char nomeGrafo[NLEN] = "wiki-Vote";

int main()
{
    // Cria tabelas enormes para as distâncias
    float*** dists = (float***) malloc(sizeof(float**)*N);
    for(int i = 0; i < N; i++)
    {
        dists[i] = (float**) malloc(sizeof(float*)*N);
        for(int j = 0; j < N; j++)
            dists[i][j] = (float*) malloc(sizeof(float)*(TAM+1));
    }


    // Cria tabelas enormes para as coordenadas
    float*** coords = (float***) malloc(sizeof(float**)*N);
    for(int i = 0; i < N; i++)
    {
        coords[i] = (float**) malloc(sizeof(float*)*(DIM+1));
        for(int j = 0; j < DIM+1; j++)
            coords[i][j] = (float*) malloc(sizeof(float)*(TAM+1));
    }


    // Preenche tabelas com valores de vazio
    for(int i = 0; i < N; i++)
        for(int j = 0; j < N; j++)
            for(int k = 0; k <= TAM; k++)
                dists[i][j][k] = -1;
    
    for(int i = 0; i < N; i++)
        for(int k = 0; k <= TAM; k++)
            coords[i][0][k] = -1;


    // Lê o primeiro embedding
    char fileName[NLEN];
    float a, b, c;
    int max = 0;

    sprintf(fileName, "emb/%s-2d.emb", nomeGrafo);
    FILE* arq = fopen(fileName, "r");
    fscanf(arq, "%f %f", &a, &b);

    for(int i = 0; fscanf(arq, "%f %f %f", &a, &b, &c) != EOF; i++)
    {
        max = MAX(max, a);
        coords[i][0][0] = a;
        coords[i][1][0] = b;
        coords[i][2][0] = c;
    }
    fclose(arq);


    // Lê os demais embeddings
    for(int i = 0, k = 1; i < TAM; i++, k++)
    {
        sprintf(fileName, "emb/%s-2d-%d%%rem.emb", nomeGrafo, percents[i]);
        FILE* arq = fopen(fileName, "r");
        fscanf(arq, "%f %f", &a, &b);

        for(int j = 0; fscanf(arq, "%f %f %f", &a, &b, &c) != EOF; j++)
        {
            coords[j][0][k] = a;
            coords[j][1][k] = b;
            coords[j][2][k] = c;
        }

        fclose(arq);
    }


    // Cria tradutor entre nome do nó e posição no primeiro embedding
    int dict[max+1];
    for(int i = 0; i <= max; i++)
        dict[i] = -1;

    for(int i = 0; i < N; i++)
    {
        if(coords[i][0][0] == -1) break;
        dict[(int) coords[i][0][0]] = i;
    }


    // Calcula distâncias entre pares
    for(int k = 0; k <= TAM; k++)
    {
        for(int i = 0; coords[i][0][k] != -1; i++)
        {
            dists[i][i][k] = 0;
            for(int j = i+1; coords[j][0][k] != -1; j++)
                dists[i][j][k] = dists[j][i][k] = DIST(coords[i][1][k], coords[i][2][k], coords[j][1][k], coords[j][2][k]);
        }
    }


    // Lê os grupos de cada vértice
    int telco[max+1][TAM];
    for(int i = 0; i <= max; i++)
        for(int j = 0; j < TAM; j++)
            telco[i][j] = -1;

    for(int i = 0; i < TAM; i++)
    {
        sprintf(fileName, "emb/%s-2d-%d%%rem.telco", nomeGrafo, percents[i]);
        FILE* arq = fopen(fileName, "r");

        for(int j = 0, c, d; fscanf(arq, "%d,%d", &c, &d) != EOF; j++)
            telco[c][i] = d;

        fclose(arq);
    }


    // Escreve arquivos com as distâncias
    for(int p = 0, k = 1; p < TAM; p++, k++)
    {
        sprintf(fileName, "emb/%s-2d-%d%%rem.dist", nomeGrafo, percents[p]);
        FILE* arq = fopen(fileName, "w");
        fprintf(arq, "distBefore,distNow,grupo\n");

        for(int i = 0; coords[i][0][k] != -1; i++)
            for(int j = i; coords[j][0][k] != -1; j++)
            {
                int x = (int) coords[i][0][k];
                int y = (int) coords[j][0][k];
                int grupo = telco[x][p];

                if(telco[x][p] != telco[y][p] || grupo < 0)
                    continue;

                fprintf(arq, "%f,%f,%d\n", dists[dict[x]][dict[y]][0], dists[i][j][k], grupo);
            }

        fclose(arq);
    }


    // Libera tabelas
    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < N; j++)
            free(dists[i][j]);
        free(dists[i]);
    }
    free(dists);

    for(int i = 0; i < N; i++)
    {
        for(int j = 0; j < DIM+1; j++)
            free(coords[i][j]);
        free(coords[i]);
    }
    free(coords);
}