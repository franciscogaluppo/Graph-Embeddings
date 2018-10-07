library(ggplot2)
library(grid)
library(gridExtra)

graph.name <- "email-Enron"
porcents <- c(1, 5, 10, 20, 50, 90, 99)

# Lê o primeiro embedding e plota
y0 <- read.table(
    paste("emb/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
y0$telco <- "0"

q0 <- ggplot(y0, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle("Todas as arestas") +
    labs(x="", y="")

qlist <- list(q0)

# Lê os demais e plota
for(i in porcents)
{
    y <- read.table(
        paste("emb/", graph.name, "-2d-", i, "%rem.emb", sep=""),
        sep = " ", skip=1, col.names=c("node", "x", "y"))
    
    rem <- read.table(
        paste("emb/", graph.name, "-2d-", i, "%rem.telco", sep=""),
        sep=",", col.names=c("node", "telco"))
    rem$match <- match(as.numeric(rem$node), y$node)
    rem <- rem[!is.na(rem$match),]
    
    y$telco[rem$match] <- as.character(rem$telco)
    y <- y[order(as.numeric(y$telco)),]

    q <- ggplot(y, aes(x, y, color=telco)) +
    geom_point(shape=".") +
    theme_classic(base_size = 14) +
    ggtitle(paste("Remoção entre ",i,"%")) +
    labs(x="", y="")

    qlist <- append(qlist, list(q))
}

# Salva os plots
pdf(paste("plots/Embedding de Remoção de Arestas/",
    graph.name, ".pdf", sep=""), width=17, height=7)
n <- length(qlist)
nCol <- ceiling(sqrt(n))+1
top <- "Comparação de Rodadas do node2vec: remoção de aresta"
do.call("grid.arrange", c(qlist, ncol=nCol, top=top))
dev.off()