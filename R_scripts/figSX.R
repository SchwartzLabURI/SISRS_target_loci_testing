library(phangorn)
library(ggtree)
library(ggplot2)
library(ape)
library(dplyr)
library(glue)

#setwd("/Users/corinna/Documents/Work/Schwartz_Lab/Plant_paralog_evolution/Campanulaceae/Angiosperm353/HybPiper/All/CAMP/without_internal_stop_codons")

data <- read.table("tree_metadata2.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), ifelse(Remark!="n.a.", glue("italic({Genus})~{Remark}~italic({Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}")))))

#col <- c("Burmeistera" = "lightseagreen", "Centropogon" = "plum3", "Lysipomia" = "darkgoldenrod1", "Siphocampylus" = "royalblue3")
col <- c("B." = "lightseagreen", "C." = "plum3", "L." = "darkgoldenrod1", "S." = "royalblue3")

tree <- read.tree("SCG_SpeciesTree_supercontigs_astral3.tre")

#ggtree(rooted_tree) + geom_text(aes(label=node), hjust=-0.3) + geom_tiplab(align=FALSE, size=2)

rooted_tree <- root(tree, outgroup="Siph_manettiflorus_A200_Herber", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

rooted_tree$tip.label[ !(rooted_tree$tip.label %in% data2$Label) ] #check for species not in metadata

pdf("SCG_SpeciesTree_supercontigs_astral3.pdf", width=9, height=6.5)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
geom_treescale(x=0, y=70) + xlim(0, 3.5) + 
annotate("point", x=0, y=68, shape=21, fill="darkgray", color="black", size=2) + 
annotate("text", x=0.05, y=68, label = "> 75% node support", hjust = "left", size=2.5) + 
geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=2, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + 
#geom_tippoint(aes(color=factor(Genus)), shape=19, size=3) + 
theme(legend.position = "none") + 
geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica", size=2.5) + 
aes(color=factor(Genus)) + 
scale_color_manual(values = col, name="Genus", na.value="black") + 
geom_cladelab(node=76, label="Brevilimbatids", family="Helvetica", fontface="plain", offset=0.935) + 
geom_cladelab(node=87, label="Burmeisterids", family="Helvetica", fontface="plain", offset=0.7) + 
geom_cladelab(node=102, label="giganteus grade", family="Helvetica", fontface="plain", offset=1.128) + 
geom_cladelab(node=138, label="Peruvianids", family="Helvetica", fontface="plain", offset=0.962) + 
geom_cladelab(node=123, label="Eucentropogonids", family="Helvetica", fontface="plain", offset=0.766) + 
geom_cladelab(node=116, label="andinus clade", family="Helvetica", fontface="plain", offset=0.725) + 
geom_cladelab(node=110, label="Colombianids", family="Helvetica", fontface="plain", offset=0.815)
t2
dev.off()

ggsave(plot = t2, filename = "SCG_SpeciesTree_supercontigs_astral3.png", width = 9, height = 6.5, units = "in", limitsize = FALSE)
