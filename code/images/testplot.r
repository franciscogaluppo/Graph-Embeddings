library(igraph)
library(gridExtra)
library(GGally)
library(ggrepel)

# Lê grafo
x <- as.matrix(read.table(
    "graphs/wiki-Vote.edgelist",
    sep = ' ', header=F,
    strip.white = TRUE
    #colClasses = c("integer", "integer", "NULL")
))

head(x)

g <- graph_from_edgelist(x+1, directed=F)


# Lê embedding
y <- read.table(
    "emb/wiki-Vote.emb",
    sep = " ", skip=1
)
y[,1] <- y[,1]+1

pdf("Graph wiki-Vote.pdf")
#p <- ggnet2(g, label=T, node.color="orange")
# q <- ggplot(y, aes(V2, V3, label = V1)) +
    ## geom_text_repel() +
    # geom_point(color = 'red') +
    # theme_classic(base_size = 14) +
    # labs(x="", y="")

plot(g, vertex.size=0, vertex.label=NA, edge.arrow.size=0)

#grid.arrange(p, q)
dev.off()