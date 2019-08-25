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

So, our objective is to tackle this problem of incomplete graphs using embeddings

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
|![](plots/Readme_images/amostras-email-Enron.png?raw=true)|![](plots/Readme_images/amostras-scale-free.png?raw=true)|![](plots/Readme_images/amostras-soc-sign-bitcoinotc.png?raw=true)|![](plots/Readme_images/amostras-wiki-Vote.png?raw=true)|
|---|---|---|---|
|*FIG 5*|

|![](plots/Readme_images/amostras-email-Enron-128.png?raw=true)|![](plots/Readme_images/amostras-scale-free-128.png?raw=true)|![](plots/Readme_images/amostras-soc-sign-bitcoinotc-128.png?raw=true)|![](plots/Readme_images/amostras-wiki-Vote-128.png?raw=true)|
|---|---|---|---|
|*FIG 6*|

|![](plots/Readme_images/amostras-soc-sign-bitcoinotc-remove.png?raw=true)|
|---|
|*FIG 7*|

|![](plots/Readme_images/amostras-wiki-Vote-GCC.png?raw=true)|
|---|
|*FIG 8*|

|![](plots/Readme_images/amostras-soc-sign-bitcoinotc-128d.png?raw=true)|
|---|
|*FIG 9*|

## Struc2vec
|![](plots/Readme_images/struc2vec.png?raw=true)|
|---|
|*FIG 10*|
