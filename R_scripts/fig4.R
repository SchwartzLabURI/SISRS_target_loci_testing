library(phangorn)
library(ggtree)
library(ggplot2)
library(ape)
library(dplyr)
library(glue)

#setwd("/Users/corinna/Documents/Work/Schwartz_Lab/Plant_paralog_evolution/Campanulaceae/TargetCapture/SISRS")

data <- read.table("tree_metadata.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Info=="new" & Remark=="n.a." & Species!="sp.", glue("bolditalic({Genus}~{Species})~bold({Sample})"), ifelse(Info=="new" & Remark!="n.a." & Species!="nov.", glue("bolditalic({Genus})~bold({Remark})~bolditalic({Species})~bold({Sample})"), ifelse(Info=="new" & Species=="nov.", glue("bolditalic({Genus})~bold({Remark}~{Species}~{Sample})"), ifelse(Info=="new" & Species=="sp.", glue("bolditalic({Genus})~bold({Species}~{Sample})"), ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), ifelse(Remark!="n.a." & Info!="new", glue("italic({Genus})~{Remark}~italic({Species})~{Sample}~{Info}"), ifelse(Species=="sp." & Info!="new", glue("italic({Genus})~{Species}~{Sample}~{Info}"), glue("italic({Genus}~{Species})~{Sample}~{Info}")))))))))

col <- c("B." = "lightseagreen", "C." = "plum3", "L." = "darkgoldenrod1", "S." = "royalblue3")

# Tree with all loci, only plotted for comparison
tree <- read.tree("SISRS_SpeciesTree_astral3.tre")
rooted_tree <- root(tree, outgroup="Siph_manettiflorus_A200_Herber", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

ggtree(rooted_tree) + geom_text(aes(label=node), hjust=-0.3) + geom_tiplab(align=FALSE, size=2)

pdf("SISRS_SpeciesTree_TargetCapture_astral3.pdf", width=9, height=9)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
geom_treescale(x=0, y=95) + xlim(0, 7.5) + 
annotate("point", x=0, y=90, shape=21, fill="darkgray", color="black", size=2) + 
annotate("text", x=0.05, y=90, label = "> 75% node support", hjust = "left", size=2.5) + 
geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=2, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + 
theme(legend.position = "none") + 
geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica", size=2.5) + 
aes(color=factor(Genus)) + 
scale_color_manual(values = col, name="Genus", na.value="black") + 
geom_cladelab(node=164, label="Brevilimbatids", family="Helvetica", fontface="plain", offset=3.5) + 
geom_cladelab(node=143, label="Burmeisterids", family="Helvetica", fontface="plain", offset=1.4) + 
geom_cladelab(node=63, label="giganteus grade", family="Helvetica", fontface="plain", offset=5.35) + 
geom_cladelab(node=136, label="Peruvianids", family="Helvetica", fontface="plain", offset=4.685) + 
geom_cladelab(node=181, label="Eucentropogonids", family="Helvetica", fontface="plain", offset=2.135) + 
geom_cladelab(node=113, label="andinus clade", family="Helvetica", fontface="plain", offset=2.75) + 
geom_cladelab(node=128, label="Colombianids", family="Helvetica", fontface="plain", offset=4.38)
t2
dev.off()

# Tree used in figure
tree <- read.tree("SISRS_SCG_SpeciesTree_astral3.tre")
rooted_tree <- root(tree, outgroup="Siph_manettiflorus_A200_Herber", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

ggtree(rooted_tree) + geom_text(aes(label=node), hjust=-0.3) + geom_tiplab(align=FALSE, size=2)

pdf("SISRS_SCG_SpeciesTree_TargetCapture_astral3.pdf", width=9, height=9)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
geom_treescale(x=0, y=95) + xlim(0, 9.2) + 
annotate("point", x=0, y=90, shape=21, fill="darkgray", color="black", size=2) + 
annotate("text", x=0.05, y=90, label = "> 75% node support", hjust = "left", size=2.5) + 
geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=2, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + 
theme(legend.position = "none") + 
geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica", size=2.5) + 
aes(color=factor(Genus)) + 
scale_color_manual(values = col, name="Genus", na.value="black") + 
geom_cladelab(node=112, label="Brevilimbatids", family="Helvetica", fontface="plain", offset=4.495) + 
geom_cladelab(node=128, label="Burmeisterids", family="Helvetica", fontface="plain", offset=1.4) + 
geom_cladelab(node=110, label="giganteus grade", family="Helvetica", fontface="plain", offset=6.622) + 
geom_cladelab(node=103, label="Peruvianids", family="Helvetica", fontface="plain", offset=5.375) + 
geom_cladelab(node=177, label="Eucentropogonids", family="Helvetica", fontface="plain", offset=3.24) + 
geom_cladelab(node=153, label="andinus clade", family="Helvetica", fontface="plain", offset=2.865) + 
geom_cladelab(node=190, label="Colombianids", family="Helvetica", fontface="plain", offset=4.995)
t2
dev.off()
