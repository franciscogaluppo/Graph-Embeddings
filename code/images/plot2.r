library(igraph)
library(gridExtra)
library(GGally)
library(ggrepel)
source("code/images/plot-func.r")

emb <- "node2vec"
graph.name <- "scale-free"

# Lê grafo
x <- as.matrix(read.table(
    paste("graphs/", graph.name, ".edgelist", sep=""),
    sep = ' ', header=F, strip.white = TRUE,
    colClasses = c("integer", "integer", "NULL")
))
g <- graph_from_edgelist(x+1, directed=F)


# Lê embedding
y <- read.table(
    paste("emb/", emb, "/", graph.name, ".emb", sep=""),
    sep = " ", skip=1)
y[,1] <- y[,1]+1

components(g)$no

# Gera os plots
# FIXME:
if(components(g)$no < 1)
{
    pdf(paste("plots/node2vec ", graph.name, ".pdf", sep=""))
    plot.with.values(g, y, graph.name, F)
    dev.off()
}else
{
    pdf(paste("plots/Graph ", graph.name, ".pdf", sep=""))
    plot(g, vertex.size=0, vertex.label=NA, edge.arrow.size=0)
    dev.off()

    q <- ggplot(y, aes(V2, V3, label = V1)) +
        geom_point(color = 'red') +
        theme_classic(base_size = 14) +
        labs(x="", y="")
    ggsave((paste("plots/node2vec ", graph.name, ".pdf", sep="")), plot=q)
}