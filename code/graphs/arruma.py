grafo = "scale-free"

with open("graphs/"+grafo+".edgelist", 'r') as arq1:
    with open("graphs/"+grafo+"2.edgelist", "w") as arq2:
        for i in arq1:
            arq2.write("{} {}\n".format(*(i.split()[0:2]))) 