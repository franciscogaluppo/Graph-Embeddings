library(igraph)
library(car)
library(rgl)

emb <- "node2vec"

myColorRamp <- function(colors, values)
{
    v <- (values - min(values))/diff(range(values))
    x <- colorRamp(colors)(v)
    rgb(x[,1], x[,2], x[,3], maxColorValue = 255)
}

graph.name <- "scale-free"

# Lê grafo
x <- read.table(
    paste("graphs/", graph.name, ".edgelist", sep=""),
    sep = ' ', header=F, strip.white = TRUE
    #colClasses = c("integer", "integer", "NULL")
)

x[,1] <- as.character(x[,1])
x[,2] <- as.character(x[,2])
x <- as.matrix(x)

g <- graph_from_edgelist(x, directed=F)


# Lê embedding
y <- read.table(
    paste("emb/", emb, "/", graph.name, "-3d.emb", sep=""),
    sep = " ", skip=1)
ordem <- order(y[,1])
y <- y[ordem,]

# Salva graus em ordem crescente
deg <- degree(g)
names <- V(g)$name
y$V5 <- deg[order(as.numeric(names))]

# Salva as componentes
comps <- components(g)
ordem <- order(as.numeric(V(g)$name))
y$V6 <- comps$membership[ordem]

names(y) <- c("node", "x", "y", "z", "degree", "component")
cols <- myColorRamp(c("yellow", "red"), y$degree) 

scatter3d(x = y$x, y = y$y, z = y$z,
    surface=F, labels=as.character(y$node), xlab="x", ylab="y", zlab="z",
    axis.col = c("black", "black", "black"))

rgl.snapshot(filename = "plots/ooo.png")