library(phangorn)
library(ggtree)
library(ggplot2)
library(ape)
library(dplyr)
library(glue)

#setwd("/Users/corinna/Documents/Work/Schwartz_Lab/Plant_paralog_evolution/Campanulaceae/TargetCapture/353")

data <- read.table("tree_metadata4.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Info=="new" & Remark=="n.a." & Species!="sp.", glue("bolditalic({Genus}~{Species})~bold({Sample})"), ifelse(Info=="new" & Remark!="n.a." & Species!="nov.", glue("bolditalic({Genus})~bold({Remark})~bolditalic({Species})~bold({Sample})"), ifelse(Info=="new" & Species=="nov.", glue("bolditalic({Genus})~bold({Remark}~{Species}~{Sample})"), ifelse(Info=="new" & Species=="sp.", glue("bolditalic({Genus})~bold({Species}~{Sample})"), ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), ifelse(Remark!="n.a." & Info!="new", glue("italic({Genus})~{Remark}~italic({Species})~{Sample}~{Info}"), ifelse(Species=="sp." & Info!="new", glue("italic({Genus})~{Species}~{Sample}~{Info}"), glue("italic({Genus}~{Species})~{Sample}~{Info}")))))))))

col <- c("B." = "lightseagreen", "C." = "plum3", "L." = "darkgoldenrod1", "S." = "royalblue3")

tree <- read.tree("353_SpeciesTree_supercontigs_astral3.tre")
rooted_tree <- root(tree, outgroup="Siph_manettiflorus_A200_Herber", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

ggtree(rooted_tree) + geom_text(aes(label=node), hjust=-0.3) + geom_tiplab(align=FALSE, size=2)

pdf("353_SpeciesTree_supercontigs_TargetCapture_astral3.pdf", width=9, height=9)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
geom_treescale(x=0, y=95) + xlim(0, 3.5) + 
annotate("point", x=0, y=90, shape=21, fill="darkgray", color="black", size=2) + 
annotate("text", x=0.05, y=90, label = "> 75% node support", hjust = "left", size=2.5) + 
geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=2, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + 
theme(legend.position = "none") + 
geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica", size=2.5) + 
aes(color=factor(Genus)) + 
scale_color_manual(values = col, name="Genus", na.value="black") + 
geom_cladelab(node=184, label="Brevilimbatids", family="Helvetica", fontface="plain", offset=1.02) + 
geom_cladelab(node=103, label="Burmeisterids", family="Helvetica", fontface="plain", offset=0.76) + 
geom_cladelab(node=84, label="giganteus grade", family="Helvetica", fontface="plain", offset=1.27) + 
geom_cladelab(node=122, label="Peruvianids", family="Helvetica", fontface="plain", offset=1.085) + 
geom_cladelab(node=175, label="Eucentropogonids", family="Helvetica", fontface="plain", offset=0.907) + 
geom_cladelab(node=155, label="andinus clade", family="Helvetica", fontface="plain", offset=1.065) + 
geom_cladelab(node=148, label="Colombianids", family="Helvetica", fontface="plain", offset=0.923)
t2
dev.off()