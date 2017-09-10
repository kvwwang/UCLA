library(igraph)
library(netrw)

n_nodes = 1000
d = 0.85

set.seed(111)
gu = random.graph.game(n_nodes, 0.01, directed=F)
a = netrw(gu,damping=d,output.walk.path=T,output.visit.prob=T)

p_nvisit=a$ave.visit.prob
deg = degree(gu)

plot(1:1000,p_nvisit,main="Probability of Visiting nodes",xlab="Node",ylab="Probability")
plot(deg,p_nvisit,main="Degree vs. Probability of Visiting Node",xlab="Degree",ylab="Probability")


set.seed(111)
gd = random.graph.game(n_nodes, 0.01, directed=TRUE)
a = netrw(gd,damping=1,output.walk.path=T,output.visit.prob=T)

p_nvisit=a$ave.visit.prob
deg = degree(gd)

plot(deg,p_nvisit,main="Degree vs. Probability of Visiting Node",xlab="Degree",ylab="Probability")
plot(1:1000,p_nvisit,main="Probability of Visiting nodes",xlab="Node",ylab="Probability")





