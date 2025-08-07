library(phangorn)
library(ggtree)
library(ggplot2)
library(ape)
library(dplyr)
library(glue)

setwd("/Users/corinna/Documents/Work/Schwartz_Lab/Plant_paralog_evolution/Campanulaceae/Angiosperm353/HybPiper/Burmeistera/CAMP/without_internal_stop_codons")

data <- read.table("tree_metadata.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), glue("italic({Genus}~{Species})~{Sample}~{Info}")))

tree <- read.tree("SCG_SpeciesTree_supercontigs_wastral.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("SCG_SpeciesTree_supercontigs_wastral.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 1.5)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=TRUE, hjust=-.02, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()

tree <- read.tree("SCG_SpeciesTree_wastral.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("SCG_SpeciesTree_wastral.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 1)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=TRUE, hjust=-.02, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()

tree <- read.tree("BurSCG_SpeciesTree_wastral.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("BurSCG_SpeciesTree_wastral.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 0.7)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=TRUE, hjust=-.02, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()

tree <- read.tree("BurSCG_SpeciesTree_dna_astral3.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("BurSCG_SpeciesTree_astral3.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 0.6)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=TRUE, hjust=-.02, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()

tree <- read.tree("BurSCG_SpeciesTree_supercontigs_wastral.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("BurSCG_SpeciesTree_supercontigs_wastral.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 0.9)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=TRUE, hjust=-.02, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()

tree <- read.tree("BurSCG_SpeciesTree_supercontigs_astral3.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("BurSCG_SpeciesTree_supercontigs_astral3.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 0.9)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=TRUE, hjust=-.02, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()


tree <- read.tree("SpeciesTree_supercontigs_astral-pro3.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("SpeciesTree_supercontigs_astral-pro3.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 0.14)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.15, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()

tree <- read.tree("SpeciesTree_paralogs_astral-pro3.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("SpeciesTree_paralogs_astral-pro3.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 0.04)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.15, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()

tree <- read.tree("SpeciesTree_dna_astral-pro3.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

pdf("SpeciesTree_dna_astral-pro3.pdf", width=10, height=10)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + geom_treescale() + xlim(0, 0.04)
t2 <- t %<+% data2 + theme(legend.position = "none") + geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.15, parse=T, family="Helvetica") + geom_nodelab(aes(subset = !is.na(as.numeric(label))), geom="label", color="black", fill="whitesmoke", size=3, label.size=NA)
t2
dev.off()
