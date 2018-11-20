library(igraph)             

emb <- "node2vec"
tam.amostra <- 3000
graph.name <- "scale-free"

# Lê grafo
tabela <- read.table(
    paste("graphs/", graph.name, ".edgelist", sep=""),
    sep = ' ', header=F, strip.white = TRUE
)

# Cria grafo
tabela[,1] <- as.character(tabela[,1])
tabela[,2] <- as.character(tabela[,2])
tabela <- as.matrix(tabela)
g <- graph_from_edgelist(tabela, directed=F)

# Cria amostra
nodes <- V(g)$name
deg <- degree(g)
deg.prob <- deg/sum(deg)
amostra <- sample(nodes, size=tam.amostra, replace=F, prob=deg.prob)
vals <- data.frame(degree(g, amostra))
names(vals) <- c("degree")
amostra <- as.numeric(amostra)

# Lê os embeddings
emb1 <- read.table(
    paste("emb/", emb, "/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y")
)

emb2 <- read.table(
    paste("emb/", emb, "/", graph.name, "-2d2.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y")
)

# Coloca coords do emb1
emb1$match <- match(as.numeric(emb1$node), amostra)
emb1 <- emb1[!is.na(emb1$match),]
vals$x.1[emb1$match] <- emb1$x
vals$y.1[emb1$match] <- emb1$y

# Mapeia os embeddings
emb2$match <- match(as.numeric(emb2$node), amostra)
emb2 <- emb2[!is.na(emb2$match),]
vals$x.2[emb2$match] <- emb2$x
vals$y.2[emb2$match] <- emb2$y

# Escreve tabela
write.table(vals, col.names=F, row.names=F, sep=",",
    file=paste("amostras/", graph.name, "-EMBS.amostra", sep="")
)
