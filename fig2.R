library(phangorn)
library(ggtree)
library(ggplot2)
library(dplyr)
library(glue)
library(gridExtra)

data <- read.table("tree_metadata.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), 
                                         ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}"))))

tree <- read.tree("RAxML_bipartitions.alignment_pi_m4_nogap")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
  xlim(0, 1) + #how much space on left and right
  annotate("point", x=0, y=14, shape=21, fill="darkgray", color="black", size=3) + 
  annotate("text", x=0.04, y=14, label = "> 75% node support", hjust = "left", size=2) + 
  geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=3, 
                 shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + geom_tippoint(shape=19, size=2.5) + 
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, 
              family="Helvetica", size = 2) 
ggsave(plot = t2, filename = "RAxML_bipartitions.alignment_pi_m4_nogap.png", 
       width = 3, height = 4.5, units = "in", limitsize = FALSE)



tree <- read.nexus("Burm_alignment_pi_m4_nogap.phylip-relaxed.svdq.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

t3 <- ggtree(rooted_tree, layout="rectangular", size=1) +
  hexpand(1) +
  annotate("point", x=0, y=14, shape=21, fill="darkgray", color="black", size=3) + 
  annotate("text", x=30, y=14, label = "> 75% node support", hjust = "left", size=2) + 
  geom_nodepoint(size=3, shape=21, fill="darkgray", color="black")
t4 <- t3 %<+% data2 + geom_tippoint(shape=19, size=2.5) + 
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, 
              family="Helvetica", size = 2) 
ggsave(plot = t4, filename = "Burm_alignment_pi_m4_nogap.phylip-relaxed.svdq.png", 
       width = 3, height = 4.5, units = "in", limitsize = FALSE)


combined_plot <- grid.arrange(t2, t4, ncol = 2)
ggsave("Burm_SISRS_sites_raxml_svdq.png", plot = combined_plot, 
       width = 6, height = 4.5, units = "in")


