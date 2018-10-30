library(ggplot2)
library(grid)
library(gridExtra)

# /* Regular sizes */
# soc-sign-bitcoinotc       358
# wiki-Vote                 1050
# scale-free                281
# email-Enron               3344

# /* GCC sizes */
# soc-sign-bitcoinotc       358
# wiki-Vote                 1046
# email-Enron               3264

tam.amostra <- 3264
graph.name <- "email-Enron"
percents <- c(1, 5, 10, 20, 50, 90, 99)
qlist <- list()

# Lê os demais e plota
for(i in percents)
{
    print(i)
    # Lê distâncias
    y <- read.table(
        paste("dists/", graph.name, "-GCC-2d-", i, "%rem-", tam.amostra, ".dist", sep=""),
        sep = ",", header=T)
    
    y$d1 <- scale(y$d1)
    y$d2 <- scale(y$d2)
    y <- y[order(y$sum_degree),]
    y$log.sum.degree <- log(y$sum_degree)

    # TODO: Regressão linear

    # Plota os três plots
    telco <- ggplot(y[y$grupo == 0, ], aes(d1, d2, color=log.sum.degree)) +
        geom_point(shape=".") +
        theme_classic(base_size = 14) +
        scale_color_gradient(low="yellow", high="red") +
        ggtitle(paste("Telco: Remoção entre ",i,"%")) +
        labs(x="Distância no original", y="Distância com as remoções")

    non_telco <- ggplot(y[y$grupo == 1, ], aes(d1, d2, color=log.sum.degree)) +
        geom_point(shape=".") +
        theme_classic(base_size = 14) +
        ggtitle(paste("Não Telco: Remoção entre ",i,"%")) +
        labs(x="Distância no original", y="Distância com as remoções")

    qlist <- append(qlist, list(telco, non_telco))
}

# Salva os plots
print("Criando plot")
pdf(paste("plots/Distâncias/amostras-",
    graph.name, "-GCC.pdf", sep=""), width=17, height=17)
n <- length(qlist)
nCol <- 4
top <- "Comparação das distâncias do node2vec: remoção de aresta"
do.call("grid.arrange", c(qlist, ncol=nCol, top=top))
dev.off()
