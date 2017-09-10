library(igraph)
library(netrw)

n_nodes = 1000
d = 0.85

set.seed(111)
g = random.graph.game(n_nodes, 0.01, directed=TRUE)
a = netrw(g,damping=d,output.walk.path=T,output.visit.prob=T)

pr = page.rank(g,directed=TRUE,damping=d)
pr_nw = personalized.pagerank(g)

plot(1:1000,pr$vector,main="PageRank of Nodes in Directed Network",xlab="Node",ylab="PageRank")

pr_p = page.rank(g,directed=TRUE,damping=d,personalized=pr_nw)

plot(1:1000,pr_p$vector,main="Personalized PageRank of Nodes in Directed Network",xlab="Node",ylab="PageRank")

pr_t = page.rank(g,personalized=matrix(1/1000,1,1000))
pr_diff = pr$vector - pr_p$vector

plot(pr$vector,pr_p$vector,main="Comparing Normal and Personalized PageRank of Nodes in Directed Network",xlab="Normal PageRank",ylab="Personalized PageRank")
plot(1:1000,pr_diff,main="Comparing Normal and Personalized PageRank of Nodes in Directed Network",xlab="Node",ylab="Difference")

mean(pr_diff)

pr_nw_p = personalized.pagerank(g,prob=pr_nw)


plot(1:1000,pr$vector, axes=FALSE,xlab="",ylab="",pch=4)
par(new=TRUE)
plot(1:1000,pr_p$vector,main="Normal vs. Personalized PageRank of Nodes in Directed Network",xlab="Node",ylab="PageRank")
