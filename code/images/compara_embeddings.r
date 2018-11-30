library(ggplot2)

emb <- "struc2vec"

# Lê embedding
graph.name <- "soc-sign-bitcoinotc"
y1 <- read.table(
    paste("emb/", emb, "/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
y1$embedding <- "#1"

y2 <- read.table(
    paste("emb/", emb, "/", graph.name, "-2d2.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
y2$embedding <- "#2"

y <- rbind(y1, y2)

pdf(paste("plots/", emb, "/", graph.name, ".pdf", sep=""))
q <- ggplot(y, aes(x, y, color=embedding)) +
    geom_point() +
    theme_classic(base_size = 14) +
    ggtitle(paste("Comparação entre duas rodadas do ", emb, sep=""))
q
dev.off()