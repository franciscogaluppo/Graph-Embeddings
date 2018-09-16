import networkx as nx

g = nx.scale_free_graph(1000)
nx.write_edgelist(g, "graphs/scale-free.edgelist")