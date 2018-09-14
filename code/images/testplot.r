library(igraph)

# Lê grafo
x <- as.matrix(read.table(
    "code/node2vec-master/graph/karate.edgelist",
    sep = ' ', header=F
))

g <- graph_from_edgelist(x, directed=F)
plot(g)


# Lê embedding
y <- read.table(
    "code/node2vec-master/emb/karate.emb",
    sep = " ", skip=1
)

plot(y[,1], y[,2])