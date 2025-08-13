library(phangorn)
library(ggtree)
library(ggplot2)
library(dplyr)
library(glue)
library(gridExtra)

data <- read.table("tree_metadata2.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), 
                                         ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}"))))

tree <- read.tree("SISRS_marker_Bur.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0
rooted_tree <- drop.tip(rooted_tree, "Centro_rex_A367_Lago806")

t <- ggtree(rooted_tree, layout="rectangular", size=1) + 
  hexpand(.7) + #how much space on left and right
  geom_tree() +
  geom_text2(
    aes(label = label, subset = !isTip ),
    vjust = -0.5,
    hjust = 1.3,
    size = 2.5
  ) +
  theme_tree()

t2 <- t %<+% data2 + 
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, 
              family="Helvetica", size = 2) 
ggsave(plot = t2, filename = "SISRS_marker_Bur.tre.png", 
       width = 3, height = 4.5, units = "in", limitsize = FALSE)

tree <- read.tree("BurSCG_SpeciesTree_supercontigs_astral3.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

t3 <- ggtree(rooted_tree, layout="rectangular", size=1) + 
  hexpand(.7) + #how much space on left and right
  geom_tree() +
  geom_text2(
    aes(label = label, subset = !isTip ),
    vjust = -0.5,
    hjust = 1.3,
    size = 2.5
  ) +
  theme_tree()
t4 <- t3 %<+% data2 +
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, 
              family="Helvetica", size = 2) 
ggsave(plot = t2, filename = "BurSCG_SpeciesTree_supercontigs_astral3.tre.png", 
       width = 3, height = 4.5, units = "in", limitsize = FALSE)

combined_plot <- grid.arrange(t2, t4, ncol = 2)
ggsave("Burm_both_locus_trees.png", plot = combined_plot, 
       width = 6, height = 4.5, units = "in")
