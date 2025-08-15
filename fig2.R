library(phangorn)
library(ggtree)
library(tidyverse)
library(glue)
library(gridExtra)

data <- read.table("tree_metadata2.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), 
                                         ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}"))))

tree <- read.tree("RAxML_bipartitions.alignment_pi_m4_nogap")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

plot(rooted_tree)
nodelabels(frame = "none") #determine root node

# Get tree data
tree_data <- ggtree(rooted_tree)$data

# Filter labels: internal nodes only, not root, not empty
label_data <- tree_data %>%
  filter(!isTip, label != "", label != "Root") %>%
  mutate( hjust_val = case_when( # custom hjust
    node == 15 ~ 1,  # node 15 shifted more right
    node == 24 ~ 1,  
    node == 25 ~  1.8,  # node shifted left
    node == 18 ~  1.6,  # node shifted left
    TRUE       ~ 1.2   # default for all others
  ),
  vjust_val = case_when( # custom vjust
    node == 24 ~ 1.2,  # node 15 shifted down
    TRUE       ~ -0.5   # default for all others
  ))

t <- ggtree(rooted_tree, layout = "rectangular", size = 1) +
  hexpand(1) +
  geom_tree() +
  geom_text2(
    data = label_data,
    aes(label = label, hjust = hjust_val, vjust = vjust_val),
    size = 2.3
  ) +
  theme_tree() + coord_cartesian(clip = "off")

t2 <- t %<+% data2 +
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, 
              family="Helvetica", size = 2.5) 
ggsave(plot = t2, filename = "RAxML_bipartitions.alignment_pi_m4_nogap.png", 
       width = 3, height = 4.5, units = "in", limitsize = FALSE)



tree <- read.nexus("Burm_alignment_pi_m4_nogap.phylip-relaxed.svdq.tre")
rooted_tree <- root(tree, outgroup="Bur_isabellinus_A190_Lago405", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0


# Get tree data
tree_data <- ggtree(rooted_tree)$data

# Filter labels: internal nodes only, not root, not empty
label_data <- tree_data %>%
  filter(!isTip, label != "Root", x>0)

t3 <- ggtree(rooted_tree, layout="rectangular", size=1) +
  hexpand(1) +
  geom_tree() +
  geom_text2(
    data = label_data,
    aes(label = branch.length),
    vjust = -0.5,
    hjust = 1.3,
    size = 2.5
  ) +
  theme_tree()
t4 <- t3 %<+% data2 +
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, 
              family="Helvetica", size = 2.5) 
ggsave(plot = t4, filename = "Burm_alignment_pi_m4_nogap.phylip-relaxed.svdq.png", 
       width = 3, height = 4.5, units = "in", limitsize = FALSE)


combined_plot <- grid.arrange(t2, t4, ncol = 2)
ggsave("Burm_SISRS_sites_raxml_svdq.png", plot = combined_plot, 
       width = 6, height = 4.5, units = "in")


