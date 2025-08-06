library(phangorn)
library(ggtree)
library(ggplot2)
library(dplyr)
library(glue)
library(gridExtra)

data <- read.table("tree_metadata.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), 
                                         ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}"))))

tree <- read.tree("BurSCG_SpeciesTree_supercontigs_astral3.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
  hexpand(.9) + #how much space on left and right
  annotate("point", x=0, y=13.5, shape=21, fill="darkgray", color="black", size=3) + 
  annotate("text", x=0.04, y=13.5, label = "> 75% node support", hjust = "left", size=2) + 
  geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=3, 
                 shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + geom_tippoint(shape=19, size=2.5) + 
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, 
              family="Helvetica", size = 2) 
ggsave(plot = t2, filename = "BurSCG_SpeciesTree_supercontigs_astral3.tre.png", 
       width = 3, height = 4.5, units = "in", limitsize = FALSE)


