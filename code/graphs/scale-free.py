import networkx as nx

g = nx.scale_free_graph(10000)
nx.write_edgelist(g, "graphs/scale-free.edgelist")