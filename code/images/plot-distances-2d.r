library(ggplot2)
library(grid)
library(gridExtra)

emb <- "node2vec"
graph.name <- "soc-sign-bitcoinotc"
percents <- c(1, 5, 10, 20, 50, 90, 99)
qlist <- list()

# Lê os demais e plota
for(i in rev(percents))
{
    print(i)
    # Lê distâncias
    y <- read.table(
        paste("emb/", emb, "/", graph.name, "-2d-", i, "%rem.dist", sep=""),
        sep = ",", skip=1, col.names=c("d1", "d2", "grupo"))
    
    y$d1 <- (y$d1 - mean(y$d1))/sd(y$d1)
    y$d2 <- (y$d2 - mean(y$d2))/sd(y$d2) 

    # TODO: Regressão linear

    # TODO: Lê grafos e coloca grau como cor

    # Plota os três plots
    telco <- ggplot(y[y$grupo == 0, ], aes(d1, d2)) +
        geom_point(shape=".") +
        theme_classic(base_size = 14) +
        ggtitle(paste("Telco: Remoção entre ",i,"%")) +
        labs(x="Distância no original", y="Distância com as remoções")

    non_telco <- ggplot(y[y$grupo == 1, ], aes(d1, d2)) +
        geom_point(shape=".") +
        theme_classic(base_size = 14) +
        ggtitle(paste("Não Telco: Remoção entre ",i,"%")) +
        labs(x="Distância no original", y="Distância com as remoções")

    qlist <- append(qlist, list(telco, non_telco))
}

# Salva os plots
pdf(paste("plots/Distâncias/",
    graph.name, ".pdf", sep=""), width=17, height=17)
n <- length(qlist)
nCol <- 4
top <- "Comparação das distâncias do node2vec: remoção de aresta"
do.call("grid.arrange", c(qlist, ncol=nCol, top=top))
dev.off()
