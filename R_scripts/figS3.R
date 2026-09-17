library(phangorn)
library(ggtree)
library(ggplot2)
library(ape)
library(dplyr)
library(glue)

setwd("/Users/corinna/Documents/Work/Schwartz_Lab/Campanulaceae/TargetCapture/353")

data <- read.table("tree_metadata2.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Info=="new" & Remark=="n.a." & Species!="sp.", glue("bolditalic({Genus}~{Species})~bold({Sample})"), ifelse(Info=="new" & Remark!="n.a." & Species!="nov.", glue("bolditalic({Genus})~bold({Remark})~bolditalic({Species})~bold({Sample})"), ifelse(Info=="new" & Species=="nov.", glue("bolditalic({Genus})~bold({Remark}~{Species}~{Sample})"), ifelse(Info=="new" & Species=="sp.", glue("bolditalic({Genus})~bold({Species}~{Sample})"), ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), ifelse(Remark!="n.a." & Info!="new", glue("italic({Genus})~{Remark}~italic({Species})~{Sample}~{Info}"), ifelse(Species=="sp." & Info!="new", glue("italic({Genus})~{Species}~{Sample}~{Info}"), glue("italic({Genus}~{Species})~{Sample}~{Info}")))))))))

col <- c("B." = "lightseagreen", "C." = "plum3", "L." = "darkgoldenrod1", "S." = "royalblue3")

tree <- read.tree("353_SCG_SpeciesTree_supercontigs_astral3.tre")
rooted_tree <- root(tree, outgroup="Siph_manettiflorus_A200_Herber", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

ggtree(rooted_tree) + geom_text(aes(label=node), hjust=-0.3, size=2) + geom_tiplab(align=FALSE, size=2)

pdf("353_SCG_SpeciesTree_supercontigs_astral3.pdf", width=9, height=11)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
geom_treescale(x=0, y=120) + xlim(0, 4) + 
annotate("point", x=0, y=117, shape=21, fill="darkgray", color="black", size=2) + 
annotate("text", x=0.05, y=117, label = "> 75% node support", hjust = "left", size=2.5) + 
geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=2, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + 
theme(legend.position = "none") + 
geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica", size=2.5) + 
aes(color=factor(Genus)) + 
scale_color_manual(values = col, name="Genus", na.value="black") + 
geom_cladelab(node=190, label="Brevilimbatids", family="Helvetica", fontface="plain", offset=1.353) + 
geom_cladelab(node=210, label="Burmeisterids", family="Helvetica", fontface="plain", offset=1) + 
geom_cladelab(node=187, label="giganteus grade", family="Helvetica", fontface="plain", offset=1.97) + 
geom_cladelab(node=237, label="Peruvianids", family="Helvetica", fontface="plain", offset=1.696) + 
geom_cladelab(node=158, label="Eucentropogonids", family="Helvetica", fontface="plain", offset=1.335) + 
geom_cladelab(node=149, label="andinus clade", family="Helvetica", fontface="plain", offset=1.384) + 
geom_cladelab(node=132, label="Colombianids", family="Helvetica", fontface="plain", offset=1.196)
t2
dev.off()
