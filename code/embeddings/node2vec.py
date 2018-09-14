import networkx as nx
from node2vec import Node2Vec

# Testando com grafo aleatório
g = nx.fast_gnp_random_graph(n=20, p=0.3)
nx.write_edgelist(g, "graphs/rg.edgelist")
n2v = Node2Vec(g, dimensions=2, walk_length=10, num_walks=600, workers=10)
model = n2v.fit(window=10, min_count=1, batch_words=4)
model.wv.save_word2vec_format("emb/rg.emb")