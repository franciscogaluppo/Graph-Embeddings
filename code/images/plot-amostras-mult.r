library(ggplot2)
library(grid)
library(gridExtra)

tam.amostra <- 3000
graph.name <- "wiki-Vote"

# Lê distâncias
y <- read.table(
    paste("dists/", graph.name, "-mult.dist", sep=""),
    sep = ",", header=T)

y$d1 <- scale(y$d1)
y$d2 <- scale(y$d2)
y <- y[order(y$sum_degree),]
y$log.sum.degree <- log(y$sum_degree)

# TODO: Regressão linear

# Plota o plot
print("Criando plot")
pdf(paste("plots/Distâncias entre rodadas 128d/amostras-",
    graph.name, "-mult.pdf", sep=""), width=7, height=7)

ggplot(y, aes(d1, d2, color=log.sum.degree)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    scale_color_gradient(low="yellow", high="red") +
    ggtitle(paste("Comparação das distâncias entre rodadas 128d")) +
    labs(x="Distância no EMB1", y="Distância no EMB2")

dev.off()
