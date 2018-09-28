library(igraph)
library(ggplot2)
library(ggalt)
library(ggrepel)
library(grid)
library(gridBase)
library(gridExtra)

# Lê grafo
graph.name <- "wiki-Vote"
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
    paste("emb/", graph.name, "-2d.emb", sep=""),
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

# Cria novo grafo com a ordem correta dos vértices
h <- make_empty_graph(n=0, directed=F) + vertices(y$node) +
edges(matrix(t(get.edgelist(g)), nrow=1))

# Gera os plots
pdf(paste("plots/node2vec-2d pagerank ", graph.name, ".pdf", sep=""), width=14, height=7)
par(mfrow=c(1,2))

# Plot do grafo
# Gradiente criado por:
# https://natpoor.blogspot.com/2016/07/making-spectrumgradient-color-palette.html
resolution <- 100
palette <- colorRampPalette(c('navy','darkolivegreen1'))
normalized <- y$pagerank / max(y$pagerank, na.rm=TRUE)
colors <- palette(resolution)[as.numeric(cut(normalized, breaks=resolution))]
plot(h, vertex.color=colors, vertex.size=0, vertex.label=NA, edge.arrow.size=0)


# Combinação dos dois plots por:
# https://stackoverflow.com/questions/14124373/combine-base-and-ggplot-graphics-in-r-figure-window#14125565
plot.new()
vps <- baseViewports()
pushViewport(vps$figure)
vp1 <-plotViewport(c(1.8,1,0,1))

# Plot do embedding
q <- ggplot(y, aes(x, y, label=lab, color=pagerank)) +
    geom_point() +
    geom_encircle(aes(group=component), col=y$component) +
    geom_text_repel(color="snow4") +
    scale_color_gradient(low='navy', high='darkolivegreen1') +
    theme_classic(base_size = 14) +
    labs(x="", y="")

print(q,vp = vp1)
dev.off()