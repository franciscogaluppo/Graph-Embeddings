library(igraph)
library(ggplot2)
library(grid)
library(gridExtra)

writeLines("Bibliotecas carregadas.")

dim <- 128
emb <- "node2vec"
graph.name <- "email-Enron"
percents <- c(1, 5, 10, 20, 50, 90, 99)

# Lê embedding sem remoção
embe <- read.table(
    paste("emb/", emb, "/", graph.name, "-", dim, "d.emb", sep=""),
    sep = " ", skip=1)
writeLines("Embedding original carregado.")

qlist <- list()
tam.amostra <- 0
percents <- percents[order(percents)]

for(j in length(percents):1)
{
    i <- percents[j]
    writeLines(paste("\n\nPercents: ", i, "%", sep=""))

    # Lê grafo
    tabela <- read.table(
        paste("graphs/", graph.name, "-", dim, "d-", i, "%rem.edgelist", sep=""),
        sep = ' ', header=F, strip.white = TRUE
    )
    writeLines("Grafo lido.")

    # Cria grafo
    tabela[,1] <- as.character(tabela[,1])
    tabela[,2] <- as.character(tabela[,2])
    tabela <- as.matrix(tabela)
    g <- graph_from_edgelist(tabela, directed=F)
    writeLines("Grafo criado.")

    # Tamanho da amostra
    if(j == length(percents))
    {
        tam.amostra <- length(V(g))
        writeLines(paste("Tamanho da amostra: ", tam.amostra, sep=""))
    }

    # Cria amostra
    nodes <- V(g)$name
    deg <- degree(g)
    deg.prob <- deg/sum(deg)
    amostra <- sample(nodes, size=tam.amostra, replace=F, prob=deg.prob)
    vals <- data.frame(degree(g, amostra))
    names(vals) <- c("degree")
    amostra <- as.numeric(amostra)
    writeLines("Amostra criada.")

    # Lê embedding
    tabela <- read.table(
        paste("emb/", emb, "/", graph.name, "-", dim, "d-", i, "%rem.emb", sep=""),
        sep = " ", skip=1)

    tabela$match <- match(as.numeric(tabela[,1]), amostra)
    tabela <- tabela[!is.na(tabela$match),]

    for(j in 1:dim)
        vals[tabela$match, j+1] <- tabela[,j+1]
    
    writeLines("Primeiro embedding lido.")

    # Coloca coords do emb original
    coords <- embe
    coords$match <- match(as.numeric(coords[,1]), amostra)
    coords <- coords[!is.na(coords$match),]

    for(j in 1:dim)
        vals[coords$match, dim+1+j] <- coords[,j+1]

    writeLines("Segundo embedding lido.")

    # Lê os grupos
    tabela <- read.table(
        paste("emb/", emb, "/", graph.name, "-", dim, "d-", i, "%rem.telco", sep=""),
        sep=",", col.names=c("node", "telco"))
    
    writeLines("Grupo lido.")
    
    tabela$match <- match(as.numeric(tabela$node), amostra)
    tabela <- tabela[!is.na(tabela$match),]
    vals$telco[tabela$match] <- tabela$telco

    # Primeira parte da tabela
    a <- 2:(dim+1)
    b <- (dim+2):(2*dim+1)

    aux <- vals[vals$telco == 1,]
    tam <- length(aux$telco)

    prov1 <- as.matrix(dist(aux[,a], diag=T))
    prov1 <- prov1[lower.tri(prov1,diag=T)]

    prov2 <- as.matrix(dist(aux[,b], diag=T))
    prov2 <- prov2[lower.tri(prov2,diag=T)]

    prov3 <- as.matrix(dist(matrix(aux[,1], ncol=1), diag=T))
    prov3 <- log(prov3[lower.tri(prov3,diag=T)])

    prov4 <- rep(1, tam*(tam+1)/2)
    
    df1 <- data.frame(prov1, prov2, prov3, prov4)
    
    writeLines("Primeira parte da tabela de distâncias criada.")

    # Segunda parte da tabela
    aux <- vals[vals$telco == 0,]
    tam <- length(aux$telco)

    prov1 <- as.matrix(dist(aux[,a], diag=T))
    prov1 <- prov1[lower.tri(prov1,diag=T)]

    prov2 <- as.matrix(dist(aux[,b], diag=T))
    prov2 <- prov2[lower.tri(prov2,diag=T)]

    prov3 <- as.matrix(dist(matrix(aux[,1], ncol=1), diag=T))
    prov3 <- log(prov3[lower.tri(prov3,diag=T)])

    prov4 <- rep(0, tam*(tam+1)/2)
    df2 <- data.frame(prov1, prov2, prov3, prov4)

    writeLines("Segunda parte da Tabela de distâncias criada.")

    # Combina tabela
    y <- rbind(df1, df2)
    names(y) <- c("d1", "d2", "log.sum.degree", "grupo")

    y$d1 <- scale(y$d1)
    y$d2 <- scale(y$d2)
    y <- y[order(y$log.sum.degree),]

    writeLines("Tabela de distâncias criada.")

    # Plota os dois tipos de gráficos
    telco <- ggplot(y[y$grupo == 0, ], aes(d2, d1, color=log.sum.degree)) +
        geom_point(shape=".") +
        theme_classic(base_size = 14) +
        scale_color_gradient(low="yellow", high="red") +
        geom_smooth(method='lm',colour="pink") +
        geom_abline(slope=1, colour="green") +
        ggtitle(paste("Telco: Remoção entre ",i,"%")) +
        labs(x="Distância no original", y="Distância com as remoções")
    writeLines("Plot de distâncias entre telcos criado.")

    non_telco <- ggplot(y[y$grupo == 1, ], aes(d2, d1, color=log.sum.degree)) +
        geom_point(shape=".") +
        theme_classic(base_size = 14) +
        geom_smooth(method='lm', colour="pink") +
        geom_abline(slope=1, colour="green") +
        ggtitle(paste("Não Telco: Remoção entre ",i,"%")) +
        labs(x="Distância no original", y="Distância com as remoções")
    writeLines("Plot de distâncias entre não telcos criado.")

    qlist <- append(qlist, list(telco, non_telco))
}

# Salva os plots
writeLines("\n\nSalvando pdf.")
qlist <- rev(qlist)
pdf(paste("plots/amostras-",
    graph.name, "-", dim, "d.pdf", sep=""), width=17, height=17)
n <- length(qlist)
nCol <- 4
top <- "Comparação das distâncias do node2vec: remoção de aresta"
do.call("grid.arrange", c(qlist, ncol=nCol, top=top))
dev.off()