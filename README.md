# Embeddings on graphs with missing edges

This repository contains the code used to research about how we could use embedding algorithms to extract information of graphs with missing edges. Most of our analysis are in this README, but feel free to ask about our project.

All of the researchers are from the Computer Science Department in Universidade Federal de Minas Gerais (UFMG), Brazil:

Francisco Galuppo Azevedo - franciscogaluppo@dcc.ufmg.br

Fabricio Murai - murai@dcc.ufmg.br

## How to run our code

*To be written...*

## Introduction
In our problem, we assume that the vertices of every graph have been partitioned between two sets, A and B. The edges between each pair of vertices in B are unknown. We want to extract information from this incomplete graph about the original one. Consider that we know which partion each vertex belongs.

|![](plots/Readme_images/original.png?raw=true)|![](plots/Readme_images/remocao.png?raw=true)|
|---|---|

Let's talk about embeddings. The informal definition (which will be enough for us) of a embedding is a map between each vertex of a graph to a vector in a real vector space. In this work, we mainly used  *[node2vec](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5108654/)*, a embedding algorithm based on biased random walks on graphs.

|![](plots/Readme_images/emb_bitcoin.png?raw=true)|
|---|
|*A graph representation of the soc-sign-bitcoinotc network (left) and its embedding using 2 dimensions and the component each vertex belongs, highlighting the vertex (its id) with highest degree of every component (right). The color represents the log-degree of the vertex.*|

So, our objective is to tackle this problem of incomplete graphs using embeddings.

## Embeddings
We decided to work with networks of different sizes, densities and natures. Check the table:

|Dataset|Number of vertices: n|Number of edges: m | m/n |Real|
|---|---|---|---|---|
|Bitcoin OTC|5,881|35,592|6.05|Yes|
|Enron Email|36,692|183,831|5.01|Yes|
|Wiki-vote|7,115|103,689|14.57|Yes|
|scale-free|10,000|18,182|1.82|No|

As we'll see, some of these features show how robust a graph can be in our problem. 

As we saw in the previous plot, most embeddings in 2 dimensions look just like a parabola. The highest degree vertices are mostly in the "inner part" of the cloud of points.

|![](plots/Readme_images/bitcoin_3d.png?raw=true)|
|---|
|*A 3d embedding of soc-sign-bitcoinotc network. Colors represent the component.*|

In the plot above we can see what looks like a paraboloid (maybe not the best angle to make a plot), whith smaller components far from the center of the cloud.

One important thing to note is the random aspect of the embedding, two embeddings of the same graph will not be the same. They may differ on scale and rotation.

|![](plots/Readme_images/compara_scale-free.png?raw=true)|
|---|
|*Two embeddings of the scale-free network.*|

So, let's simulate our problem. In the plots below, the B partition has 0%, 1%, 5%, 10%, 20%, 50%, 90%, 99% of the vertices. As we can see, as we increase the size of B we lose a lot of information about the original embedding. When B reaches 99% we have a completely different embedding, with small cores (probabbly high degree vertices).

|![](plots/Readme_images/remove_wiki-Vote.png?raw=true)|
|---|
|*Simulations of our problem using the wiki-Vote network, A in orange and B in blue.*|

## Distance
An approach is to study how the distances between pairs of vertices varies over different embeddings. That's what we did in this section.

Considering that for a graph on n vertices we would have O(n<sup>2</sup>) distances, we opted for a sampling method: we randomly chose 3000 vertices with probability proportional to its degree, for each graph. The plots below show each pair of the sample, and the axis are the normalized distance in different embeddings (2 dimensions). The color represents the log of the sum of the degrees of the pair (from yellow to red).

|![](plots/Readme_images/amostras-email-Enron.png?raw=true)|![](plots/Readme_images/amostras-scale-free.png?raw=true)|![](plots/Readme_images/amostras-soc-sign-bitcoinotc.png?raw=true)|![](plots/Readme_images/amostras-wiki-Vote.png?raw=true)|
|---|---|---|---|
|*email-Enron*|*scale-free*|*bitcoin otc*|*wiki-Vote*|

Most of the high degree pairs are located near the identity. The wiki-Vote network (the denser network) is concentrated near the identity, while the scale-free network (the less dense network) is more sparse.

These patterns are different from the distances on embeddings with more dimensions. The plots (below, embeddings with 128 dimensions) look more like baseball bats. Wiki-Vote is the only network with two well defined regions.

|![](plots/Readme_images/amostras-email-Enron-128.png?raw=true)|![](plots/Readme_images/amostras-scale-free-128.png?raw=true)|![](plots/Readme_images/amostras-soc-sign-bitcoinotc-128.png?raw=true)|![](plots/Readme_images/amostras-wiki-Vote-128.png?raw=true)|
|---|---|---|---|
|*email-Enron*|*scale-free*|*bitcoin otc*|*wiki-Vote*|

Missing edges. Now we compare how these distances (in 2 dimensions) change when we remove the edges of pairs of vertices in B. Each pair of plots below ("hot" and "cold" colors) compares the distances between pairs in A ("hot", red is higher) to the original distances, and pairs in B ("cold", lighter blue is higher) to the original. The pairs of plots are for 1%, 5%, 10%, 20%, 50%, 90% and 99% of vertices of the sample in B.

Due to computational limitations, we again did a sampling approach. Each graph had a different sample size (the A partition had 1% of all vertices, B are their neighbors):

|Dataset|Sample size|
|---|---|
|Bitcoin OTC|358|
|Enron Email|3344|
|Wiki-vote|1050|
|scale-free|281|

We still have linear behaviour when B is large, but by 99% we have basically just noise.

|![](plots/Readme_images/amostras-soc-sign-bitcoinotc-remove.png?raw=true)|
|---|
|*Simulation of the distances of embeddings with different B sizes, 2 dimensions. soc-sign-bitcoinotc network.*|

We also did a analysis by sampling only from the greatest connected component:

|Dataset|Sample size|
|---|---|
|Bitcoin OTC|358|
|Enron Email|3264|
|Wiki-vote|1046|

Here, the results look more robust, showing more information even when B is 99%.

|![](plots/Readme_images/amostras-wiki-Vote-GCC.png?raw=true)|
|---|
|*Simulation of the distances of embeddings with different B sizesc considering the greatest connected component. Wiki-Vote network.*|

Consider the same plot but with a embedding in higher dimension (128). A lot o information is preserved. 

|![](plots/Readme_images/amostras-soc-sign-bitcoinotc-128d.png?raw=true)|
|---|
|*Simulation of the distances of embeddings with different B sizes, 128 dimensions. soc-sign-bitcoinotc network.*|

## Struc2vec
We also considered using another embedding algorithm, [struc2vec](https://arxiv.org/pdf/1704.03165.pdf). But its result was not as good, different components were close, it looked too much artificial to represent the details of the graph. 

|![](plots/Readme_images/struc2vec.png?raw=true)|
|---|
|*soc-sign-bitcoinotc struc2vec embedding with 2 dimensions.*|
