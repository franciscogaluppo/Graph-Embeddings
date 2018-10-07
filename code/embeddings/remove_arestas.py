import networkx as nx
import numpy as np
from os import system

grafo = "email-Enron"
g = nx.read_edgelist("graphs/{}.edgelist".format(grafo), delimiter=" ", nodetype=str)
nodes = g.nodes()

for i in [1, 5, 10, 20, 50]:
    rem = np.random.choice(nodes, size=int(len(nodes)*i/100))
    edge = "graphs/{}-{}{}rem.edgelist".format(grafo,i,"%")
    emb = "emb/{}-2d-{}{}rem.telco".format(grafo,i,"%")
    run = "./snap-master/examples/node2vec/node2vec -i:{} -o:emb/{}-2d-{}{}rem.emb -d:2 &".format(edge,grafo,i,"%")

    # Remove arestas
    f = g.copy()
    for j in rem:
        for k in rem:
            if f.has_edge(j, k) and i != j:
                f.remove_edge(j, k)
            
            if len(f.edges(j)) == 0:
                f.add_edge(j,j)
                            
            if len(f.edges(k)) == 0:
                f.add_edge(k,k)

    nx.write_edgelist(f, edge, data=False)
    
    # Escreve quem foi removido
    with open(emb, "w") as arq:
        for i in nodes:
            arq.write("{},{}\n".format(i, 1 if i in rem else 0))

    # Roda o node2vec
    system(run)