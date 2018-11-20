library(igraph)

# soc-sign-bitcoinotc       358
# wiki-Vote                 1046
# scale-free                281
# email-Enron               3264

emb <- "node2vec"
tam.amostra = 358
graph.name <- "soc-sign-bitcoinotc"
percents <- c(1, 5, 10, 20, 50, 90, 99)

# Vértices da GCC
tabela <- read.table(
    paste("graphs/", graph.name, ".edgelist", sep=""),
    sep = ' ', header=F, strip.white = TRUE
)

tabela[,1] <- as.character(tabela[,1])
tabela[,2] <- as.character(tabela[,2])
tabela <- as.matrix(tabela)
h <- graph_from_edgelist(tabela, directed=F)
comps <- components(h)
gcc <- names(comps$membership[comps$membership == which.max(comps$csize)])

# Lê embedding sem remoção
emb <- read.table(
    paste("emb/", emb, "/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))

for(i in percents)
{
    # Lê grafo
    tabela <- read.table(
        paste("graphs/", graph.name, "-", i, "%rem.edgelist", sep=""),
        sep = ' ', header=F, strip.white = TRUE
    )

    # Cria grafo
    tabela[,1] <- as.character(tabela[,1])
    tabela[,2] <- as.character(tabela[,2])
    tabela <- as.matrix(tabela)
    g <- graph_from_edgelist(tabela, directed=F)

    # Cria amostra
    nodes <- intersect(V(g)$name, gcc)
    deg <- degree(g, nodes)
    deg.prob <- deg/sum(deg)
    amostra <- sample(nodes, size=tam.amostra, replace=F, prob=deg.prob)
    vals <- data.frame(degree(g, amostra))
    names(vals) <- c("degree")
    amostra <- as.numeric(amostra)

    # Lê embedding
    tabela <- read.table(
        paste("emb/", emb, "/", graph.name, "-2d-", i, "%rem.emb", sep=""),
        sep = " ", skip=1, col.names=c("node", "x", "y"))

    tabela$match <- match(as.numeric(tabela$node), amostra)
    tabela <- tabela[!is.na(tabela$match),]
    vals$x.r[tabela$match] <- tabela$x
    vals$y.r[tabela$match] <- tabela$y

    # Coloca coords do emb original
    coords <- emb
    coords$match <- match(as.numeric(coords$node), amostra)
    coords <- coords[!is.na(coords$match),]
    vals$x.o[coords$match] <- coords$x
    vals$y.o[coords$match] <- coords$y

    # Lê os grupos
    tabela <- read.table(
        paste("emb/", emb, "/", graph.name, "-2d-", i, "%rem.telco", sep=""),
        sep=",", col.names=c("node", "telco"))
    
    tabela$match <- match(as.numeric(tabela$node), amostra)
    tabela <- tabela[!is.na(tabela$match),]
    vals$telco[tabela$match] <- tabela$telco

    # Escreve tabela
    write.table(vals, col.names=F, row.names=F, sep=",",
        file=paste("amostras/", graph.name, "-GCC-", i, "%rem-", tam.amostra, ".amostra", sep="")
    )
}