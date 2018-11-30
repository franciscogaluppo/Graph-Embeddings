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

# Componente e pagerank
comps <- components(g)
rank <- page_rank(g, vids=y$node)$vector
y$component <- comps$membership[y$node]
y$pagerank <- rank

# Salva os vértices de maior score de cada componente
y$lab <- ""
for(i in 1:comps$no)
{
    vertice <- names(which.max(rank[y$component==i]))
    y$lab[match(vertice, y$node)] <- vertice
}

# Pontos de maior score aparecendo por cima
y <- y[order(y$pagerank),]


# Gera os plots
pdf(paste("plots/", emb, "/", graph.name, ".pdf", sep=""))

# Plot do embedding
q <- ggplot(y, aes(x, y, label=lab, color=pagerank)) +
    geom_point() +
    geom_encircle(aes(group=component), col=y$component) +
    geom_text_repel(color="snow4") +
    scale_color_gradient(low='navy', high='darkolivegreen1') +
    theme_classic(base_size = 14) +
    labs(x="", y="")
q
dev.off()