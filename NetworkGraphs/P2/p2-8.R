library(igraph)
datapath = "D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data"
setwd(datapath)

g<-read.graph("actid_net_edgelist.txt",format="ncol")
prank = page.rank(g,directed=T,damping=0.85)

ids = V(g)$name
prank_scaled = round(prank$vector*10^5,4)

write(ids,"pagerank_file.txt",sep="\t",ncolumns = length(ids))
write(prank_scaled,"pagerank_file.txt",sep="\t",ncolumns = length(ids),append = TRUE)


#  LM ------------------------------------------------------------------

com1_data <- read.delim("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/com1_data.txt", header=FALSE)
colnames(com1_data) = c('Rating','Genre','N_acts','PR1','PR2','PR3','PR4','PR5','Director')

Rating = com1_data$Rating
Genre = com1_data$Genre
N_acts = com1_data$N_acts
PR1 = com1_data$PR1
PR2 = com1_data$PR2
PR3 = com1_data$PR3
PR4 = com1_data$PR4
PR5 = com1_data$PR5
Director = com1_data$Director

lm <- lm(Rating ~ PR1+PR2+PR3+PR4+PR5+Director)
summary(lm)

lm2 <- lm(Rating ~ PR1+PR2+PR3+PR4+PR5+Director+N_acts)
summary(lm2)

lm3 <- lm(Rating ~ PR1+PR2+PR3+PR4+PR5+Director+N_acts+Genre)
summary(lm3)


glm <- glm(com1_data$Rating ~ com1_data$Genre+com1_data$N_acts+com1_data$PR1+com1_data$PR2+com1_data$PR3+com1_data$PR4+com1_data$PR5+com1_data$Director)
summary(glm)

glm2 <- glm(com1_data$Rating ~ com1_data$N_acts+com1_data$PR1+com1_data$PR2+com1_data$PR3+com1_data$PR4+com1_data$PR5+com1_data$Director)
summary(lm2)

glm3 <- glm(com1_data$Rating ~ com1_data$PR1+com1_data$PR2+com1_data$PR3+com1_data$PR4+com1_data$PR5+com1_data$Director)
summary(lm3)



# Predict -----------------------------------------------------------------
new_data <- read.delim("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/new_data.txt", header=FALSE)
colnames(new_data) = c('Name','Rating','Genre','N_acts','PR1','PR2','PR3','PR4','PR5','Director')

p1 = predict(lm,new_data)
p2 = predict(lm2,new_data)
p3 = predict(lm3,new_data)
