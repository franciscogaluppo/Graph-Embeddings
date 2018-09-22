library(ggplot2)
library(igraph)
library(gridExtra)

n <- 1000000
g <- erdos.renyi.game(n, 1/n)
size <- components(g)$csize

values <- unique(size)
values <- values[order(values)]

freq <- as.numeric(as.matrix(table(size)))
freq <- freq / sum(freq)
samples.greater <- 1 - cumsum(freq)

df <- data.frame(values, samples.greater)

p <- qplot(size, geom="histogram", bins=100)

q <- qplot(size, geom="histogram", bins=100) +
    scale_x_continuous(trans='log10') +
    scale_y_continuous(trans='log10')

r <- ggplot(df, aes(values, samples.greater)) +
    geom_line() +
    scale_x_continuous(trans='log10') +
    scale_y_continuous(trans='log10') +
    labs(x="size", y="samples with value > size")

pdf("plots/critical_random_graph_4.pdf")
grid.arrange(p, q, r,
    top="Tamanho das componentes para n=1000000 e p=1/n")
dev.off()