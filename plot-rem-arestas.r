library(ggplot2)
library(gridExtra)

graph.name <- "email-Enron"

# FIXME: Leitura de entrada horroroza, arruma isso por favor
y0 <- read.table(
    paste("emb/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
y0$telco <- "0"

y1 <- read.table(
    paste("emb/", graph.name, "-2d-1%rem.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
k <- read.table(paste("emb/", graph.name, "-2d-1%rem.telco", sep=""), sep=",")
y1$telco[match(as.numeric(k[,1]), y1$node)] <- as.character(k[,2])
y1 <- y1[order(as.numeric(y1$telco)),]

y5 <- read.table(
    paste("emb/", graph.name, "-2d-5%rem.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
k <- read.table(paste("emb/", graph.name, "-2d-5%rem.telco", sep=""), sep=",")
y5$telco[match(as.numeric(k[,1]), y5$node)] <- as.character(k[,2])
y5 <- y5[order(as.numeric(y5$telco)),]

y10 <- read.table(
    paste("emb/", graph.name, "-2d-10%rem.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
k <- read.table(paste("emb/", graph.name, "-2d-10%rem.telco", sep=""), sep=",")
y10$telco[match(as.numeric(k[,1]), y10$node)] <- as.character(k[,2])
y10 <- y10[order(as.numeric(y10$telco)),]

y20 <- read.table(
    paste("emb/", graph.name, "-2d-20%rem.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
k <- read.table(paste("emb/", graph.name, "-2d-20%rem.telco", sep=""), sep=",")
y20$telco[match(as.numeric(k[,1]), y20$node)] <- as.character(k[,2])
y20 <- y20[order(as.numeric(y20$telco)),]

y50 <- read.table(
    paste("emb/", graph.name, "-2d-50%rem.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
k <- read.table(paste("emb/", graph.name, "-2d-50%rem.telco", sep=""), sep=",")
y50$telco[match(as.numeric(k[,1]), y10$node)] <- as.character(k[,2])
y50 <- y50[order(as.numeric(y50$telco)),]

# FIXME: o mesmo vale para os plots
pdf(paste("plots/Embedding de Remoção de Arestas/",
    graph.name, ".pdf", sep=""), width=14, height=7)

q0 <- ggplot(y0, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle("Todas as arestas") +
    labs(x="", y="")

q1 <- ggplot(y1, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle("Remoção entre 1%") +
    labs(x="", y="")

q5 <- ggplot(y5, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle("Remoção entre 5%") +
    labs(x="", y="")

q10 <- ggplot(y10, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle("Remoção entre 10%") +
    labs(x="", y="")
    
q20 <- ggplot(y20, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle("Remoção entre 20%") +
    labs(x="", y="")

q50 <- ggplot(y50, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle("Remoção entre 50%") +
    labs(x="", y="")

grid.arrange(q0, q1, q5, q10, q20, q50, ncol=3, top="Comparação de Rodadas do node2vec: remoção de aresta")
dev.off()