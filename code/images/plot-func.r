plot.func <- function(edgelist, embedding)
{
    library(igraph)
    library(gridExtra)
    library(GGally)
    library(ggrepel)

    # Lê grafo
    x <- as.matrix(read.table(
        edgelist,sep = ' ',
        header=F, strip.white = TRUE,
        colClasses = c("integer", "integer", "NULL")
    ))
    g <- graph_from_edgelist(x+1, directed=F)

    # Lê embedding
    y <- read.table(
        embedding,
        sep = " ", skip=1
    )
    y[,1] <- y[,1]+1

    # Cria os plots
    p <- ggnet2(g, label=T, node.color="orange")
    q <- ggplot(y, aes(V2, V3, label = V1)) +
        geom_text_repel() +
        geom_point(color = 'red') +
        theme_classic(base_size = 14) +
        labs(x="", y="")

    grid.arrange(p, q)
}