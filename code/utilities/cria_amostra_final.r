library(igraph)

# soc-sign-bitcoinotc       353
# wiki-Vote                 1366
# scale-free                260
# email-Enron               3283

dim <- 128
emb <- "node2vec"
tam.amostra <- 353
graph.name <- "soc-sign-bitcoinotc"
percents <- c(1, 5, 10, 20, 50, 90, 99)

# Lê embedding sem remoção
embe <- read.table(
    paste("emb/", emb, "/", graph.name, "-", dim, "d.emb", sep=""),
    sep = " ", skip=1)

for(i in percents)
{
    # Lê grafo
    tabela <- read.table(
        paste("graphs/", graph.name, "-", dim, "d-", i, "%rem.edgelist", sep=""),
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

    # Lê embedding
    tabela <- read.table(
        paste("emb/", emb, "/", graph.name, "-", dim, "d-", i, "%rem.emb", sep=""),
        sep = " ", skip=1)

    tabela$match <- match(as.numeric(tabela[,1]), amostra)
    tabela <- tabela[!is.na(tabela$match),]

    for(j in 1:dim)
        vals[tabela$match, j+1] <- tabela[,j+1]

    # Coloca coords do emb original
    coords <- embe
    coords$match <- match(as.numeric(coords[,1]), amostra)
    coords <- coords[!is.na(coords$match),]

    for(j in 1:dim)
        vals[coords$match, dim+1+j] <- coords[,j+1]

    # Lê os grupos
    tabela <- read.table(
        paste("emb/", emb, "/", graph.name, "-", dim, "d-", i, "%rem.telco", sep=""),
        sep=",", col.names=c("node", "telco"))
    
    tabela$match <- match(as.numeric(tabela$node), amostra)
    tabela <- tabela[!is.na(tabela$match),]
    vals$telco[tabela$match] <- tabela$telco

    # Escreve tabela
    write.table(vals, col.names=F, row.names=F, sep=",",
        file=paste("amostras/", graph.name, "-", dim, "d-", i, "%rem-", tam.amostra, ".amostra", sep="")
    )
}