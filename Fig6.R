library(phangorn)
library(ggtree)
library(ggplot2)
library(ape)
library(dplyr)
library(glue)

#setwd("/Users/corinna/Documents/Work/Schwartz_Lab/Plant_paralog_evolution/Campanulaceae/Angiosperm353/HybPiper/All/CAMP/without_internal_stop_codons")

data <- read.table("tree_metadata2.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}"))))

#col <- c("Burmeistera" = "lightseagreen", "Centropogon" = "plum3", "Lysipomia" = "darkgoldenrod1", "Siphocampylus" = "royalblue3")
col <- c("B." = "lightseagreen", "C." = "plum3", "L." = "darkgoldenrod1", "S." = "royalblue3")

tree <- read.tree("SCG_SpeciesTree_supercontigs_astral3.tre")

t <- ggtree(tree, layout="rectangular", size=1, branch.length="none") + geom_text(aes(label=node)) + geom_tiplab(align=TRUE, hjust=-.15)
t

rooted_tree <- root(tree, node=124, resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

rooted_tree$tip.label[ !(rooted_tree$tip.label %in% data2$Label) ] #check for species not in metadata

#pdf("SCG_SpeciesTree_supercontigs_astral3.pdf", width=15, height=15)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale(x=0, y=78) + xlim(0, 3.5) + 
  annotate("point", x=0, y=75, shape=21, fill="darkgray", color="black", size=3) + 
  annotate("text", x=0.05, y=75, label = "> 75% node support", hjust = "left") + 
  geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=3, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + 
  #geom_tippoint(aes(color=factor(Genus)), shape=19, size=1) + 
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica", size=3) + 
  aes(color=factor(Genus)) + 
  scale_color_manual(values = col, name="Genus", na.value="black") + 
  geom_cladelab(node=97, label="Brevilimbatids", family="Helvetica", fontface="plain", offset=1.306) +
  geom_cladelab(node=93, label="Burmeisterids", family="Helvetica", fontface="plain", offset=0.9) +
  geom_cladelab(node=111, label="giganteus grade", family="Helvetica", fontface="plain", offset=1.58) +
  geom_cladelab(node=114, label="Peruvianids", family="Helvetica", fontface="plain", offset=1.418) +
  geom_cladelab(node=149, label="Eucentropogonids", family="Helvetica", fontface="plain", offset=1.19) +
  geom_cladelab(node=157, label="andinus clade", family="Helvetica", fontface="plain", offset=1.155) +
  geom_cladelab(node=131, label="Colombianids", family="Helvetica", fontface="plain", offset=1.025)
t2
#dev.off()

ggsave(plot = t2, filename = "SCG_SpeciesTree_supercontigs_astral3.png", width = 6.5, height = 9, units = "in", limitsize = FALSE)
