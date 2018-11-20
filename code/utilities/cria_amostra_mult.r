library(igraph)             

emb <- "node2vec"
dim <- 128
tam.amostra <- 3000
graph.name <- "email-Enron"


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
    paste("emb/", emb, "/", graph.name, "-128d.emb", sep=""),
    sep = " ", skip=1
)

emb2 <- read.table(
    paste("emb/", emb, "/", graph.name, "-128d2.emb", sep=""),
    sep = " ", skip=1
)

# Coloca coords do emb1
emb1$match <- match(as.numeric(emb1[,1]), amostra)
emb1 <- emb1[!is.na(emb1$match),]
len <- length(vals[1,])

for(i in 1:dim)
    vals[emb1$match,len+i] <- emb1[,1+i]

# Mapeia os embeddings
emb2$match <- match(as.numeric(emb2[,1]), amostra)
emb2 <- emb2[!is.na(emb2$match),]
len <- length(vals[1,])

for(i in 1:dim)
    vals[emb2$match,len+i] <- emb2[,1+i]

dim(vals)

# Escreve tabela
write.table(vals, col.names=F, row.names=F, sep=",",
    file=paste("amostras/", graph.name, "-mult.amostra", sep="")
)
