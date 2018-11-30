library(igraph)
library(ggplot2)
library(ggalt)
library(ggrepel)
library(grid)
library(gridBase)
library(gridExtra)

emb <- "struc2vec"

# Lê grafo
graph.name <- "soc-sign-bitcoinotc"
x <- read.table(
    paste("graphs/", graph.name, ".edgelist", sep=""),
    sep = ' ', header=F, strip.white = TRUE
    # colClasses = c("integer", "integer", "NULL")
)

# Cria grafo
x[,1] <- as.character(x[,1])
x[,2] <- as.character(x[,2])
x <- as.matrix(x)
g <- graph_from_edgelist(x, directed=F)

# Lê embedding
y <- read.table(
    paste("emb/", emb, "/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1, col.names=c("node", "x", "y"))
y[,1] <- as.character(y[,1])

# log-degree e componente
deg <- degree(g, y$node)
comps <- components(g)
y$log.degree <- log(deg+1)
y$component <- comps$membership[y$node]

# Salva os vértices de maior grau de cada componente
y$lab <- ""
for(i in 1:comps$no)
{
    vertice <- names(which.max(deg[y$component==i]))
    y$lab[match(vertice, y$node)] <- vertice
}

# Pontos de maior log.degree aparecendo por cima
y <- y[order(y$log.degree),]


# Gera os plots
pdf(paste("plots/", emb, "/", graph.name, ".pdf", sep=""))

# Plot do embedding
q <- ggplot(y, aes(x, y, label=lab, color=log.degree)) +
    geom_point() +
    geom_encircle(aes(group=component), col=y$component) +
    geom_text_repel(color="black") +
    scale_color_gradient(low="yellow", high="red") +
    theme_classic(base_size = 14) +
    labs(x="", y="")
q
dev.off()