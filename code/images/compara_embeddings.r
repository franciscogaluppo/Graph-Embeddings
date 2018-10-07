library(ggplot2)

# Lê embedding
graph.name <- "soc-sign-bitcoinotc"
y1 <- read.table(
    paste("emb/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
y1$embedding <- "#1"

y2 <- read.table(
    paste("emb/", graph.name, "-2d2.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
y2$embedding <- "#2"

y <- rbind(y1, y2)

pdf(paste("plots/node2vec-2d comparação rodadas ", graph.name, ".pdf", sep=""))
q <- ggplot(y, aes(x, y, color=embedding)) +
    geom_point() +
    theme_classic(base_size = 14) +
    ggtitle("Comparação entre duas rodadas do node2vec")
q
dev.off()