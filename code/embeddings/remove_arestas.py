import networkx as nx
import numpy as np
from os import system

dims = 128

# Lê o grafo original
grafo = "soc-sign-bitcoinotc"
g = nx.read_edgelist("graphs/{}.edgelist".format(grafo), delimiter=" ", nodetype=str)
nodes = g.nodes()
edges = g.edges()

# Assumo que a lista está ordenada
# Cria os samples
lista = [1, 5, 10, 20, 50, 90, 99]
rem = [[] for i in lista]
for i in range(len(lista)-1, -1, -1):
    if i == len(lista)-1:
        rem[i] = np.random.choice(nodes, size=int(len(nodes)*lista[i]/100), replace=False)
    else:
        # print(len(rem[i+1]), int(lista[i]*len(nodes)/100))
        rem[i] = np.random.choice(rem[i+1], size=int(len(nodes)*lista[i]/100), replace=False)

# Para cada tamanho
for i in range(len(lista)):
    print(len(rem[i])/len(nodes))
    edge = "graphs/{}-{}d-{}{}rem.edgelist".format(grafo,dims,lista[i],"%")
    emb = "emb/node2vec/{}-{}d-{}{}rem.telco".format(grafo,dims,lista[i],"%")
    run = "./snap-master/examples/node2vec/node2vec -i:{} -o:emb/node2vec/{}-{}d-{}{}rem.emb -d:{} &".format(edge,grafo,dims,lista[i],"%",dims)

    # Remove arestas
    n = len(rem[i])
    if g.number_of_edges() < n*(n-1)/2:
        edges_to_rem = []
        for j in g.edges():
            if j[0] in rem[i] and j[1] in rem[i]:
                edges_to_rem.append(j)
        for j in edges_to_rem:
            g.remove_edge(*j)

    else:
        for j in range(n):
            for k in range(j+1, n):
                a, b = rem[i][j], rem[i][k]
                if g.has_edge(a, b):
                    g.remove_edge(a, b)
    
    nx.write_edgelist(g, edge, data=False)
    
    # Escreve quem foi removido
    with open(emb, "w") as arq:
        for j in nodes:
            arq.write("{},{}\n".format(j, 1 if j in rem[i] else 0))

    # Roda o node2vec
    system(run)