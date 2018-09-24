library(igraph)
library(ggplot2)
library(ggalt)
library(ggrepel)
library(GGally)
library(grid)
library(gridBase)
library(gridExtra)


graph.name <- "email-Enron"

# Lê grafo
x <- read.table(
    paste("graphs/", graph.name, ".edgelist", sep=""),
    sep = ' ', header=F, strip.white = TRUE
    # colClasses = c("integer", "integer", "NULL")
)

x[,1] <- as.character(x[,1])
x[,2] <- as.character(x[,2])
x <- as.matrix(x)

g <- graph_from_edgelist(x, directed=F)


# Lê embedding
y <- read.table(
    paste("emb/", graph.name, "-2d.emb", sep=""),
    sep = " ", skip=1)
ordem <- order(y[,1])
y <- y[ordem,]

# Salva graus em ordem crescente
deg <- degree(g)
names <- V(g)$name
y$V4 <- deg[order(as.numeric(names))]

# Salva os vértices de maior grau de cada componente
comps <- components(g)
greatest.degree <- numeric()
for(i in 1:comps$no)
{
    aux <- which(comps$membership %in% i)
    greatest.degree[i] <- as.numeric(names[aux[which.max(deg[aux])]])
}
y$V5 <- y$V1
y$V5[-which(y$V1 %in% greatest.degree)] <- ""

ordem <- order(as.numeric(V(g)$name))
y$V6 <- comps$membership[ordem]


names(y) <- c("node", "x", "y", "degree", "lab", "component")

# Gera os plots
# Gradiente criado por:
# https://natpoor.blogspot.com/2016/07/making-spectrumgradient-color-palette.html
pdf(paste("plots/node2vec-2d ", graph.name, ".pdf", sep=""), width=14, height=7)
par(mfrow=c(1,2))

resolution <- 10
palette <- colorRampPalette(c('yellow','red'))
normalized <- deg / max(deg, na.rm=TRUE)
colors <- palette(resolution)[as.numeric(cut(normalized, breaks=resolution))]
plot(g, vertex.color=colors, vertex.size=0, vertex.label=NA, edge.arrow.size=0)

# Combinação dos dois plots por:
# https://stackoverflow.com/questions/14124373/combine-base-and-ggplot-graphics-in-r-figure-window#14125565
plot.new()
vps <- baseViewports()
pushViewport(vps$figure)
vp1 <-plotViewport(c(1.8,1,0,1))

q <- ggplot(y, aes(x, y, label=lab, color=degree)) +
    geom_point() +
    # geom_encircle(aes(group=component), col=y$component) +
    # geom_text_repel(color="black") +
    scale_color_gradient(low="yellow", high="red") +
    theme_classic(base_size = 14) +
    labs(x="", y="")

print(q,vp = vp1)
dev.off()