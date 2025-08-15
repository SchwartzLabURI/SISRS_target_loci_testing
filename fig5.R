#module load uri/main R-bundle-Bioconductor/3.15-foss-2021b-R-4.2.0

if (!("ape" %in% rownames(installed.packages()))) {
  install.packages("ape", repos = "https://cloud.r-project.org")
}
if (!("ggtree" %in% rownames(installed.packages()))) {
  BiocManager::install("ggtree")
}

library(phangorn)
library(ggtree)
library(ggplot2)
library(dplyr)
library(glue)

data <- read.table("tree_metadata2.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}"))))

#col <- c("Burmeistera" = "lightseagreen", "Centropogon" = "plum3", "Lysipomia" = "darkgoldenrod1", "Siphocampylus" = "royalblue3")
col <- c("B." = "lightseagreen", "C." = "plum3", "L." = "darkgoldenrod1", "S." = "royalblue3")

tree <- read.tree("SISRS_marker_Camp.tre") #/project/pi_rsschwartz_uri_edu/andromeda_transfer/rachel/Campanulaceae_markers/hybpiper_SISRSmarkers/SISRS_marker_Camp.tre
plot(tree)
nodelabels(frame = "none") #determine root node

rooted_tree <- root(tree, node=100, resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0

rooted_tree$tip.label[ !(rooted_tree$tip.label %in% data2$Label) ] #check for species not in metadata

#pdf("SISRS_marker_Camp_wastral.pdf", width=15, height=15)
t <- ggtree(rooted_tree, layout="rectangular", size=1) + #geom_treescale(x=0, y=78) + 
  #xlim(0, 11) + #how much space on left and right 
  #geom_text(aes(label=node)) +
  hexpand(.2) + #condense horizontally
  annotate("point", x=0, y=75, shape=21, fill="darkgray", color="black", size=3) + 
  annotate("text", x=0.1, y=75, label = "> 75% node support", hjust = "left") + 
  geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=3, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + 
  #geom_tippoint(aes(color=factor(Genus)), shape=19, size=2.5) + 
  theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica", size=3) + 
  aes(color=factor(Genus)) + scale_color_manual(values = col, name="Genus", na.value="black") +
  geom_cladelab(node=130, label="Brevilimbatids", family="Helvetica", fontface="plain", offset=3.8) +
  geom_cladelab(node=115, label="Burmeisterids", family="Helvetica", fontface="plain", offset=1.4) +
  #Fix clade label in Adobe Illustrator
  geom_cladelab(node=58, label="giganteus grade", family="Helvetica", fontface="plain", offset=5.52) +
  geom_cladelab(node=109, label="Peruvianids", family="Helvetica", fontface="plain", offset=4.8) +
  geom_cladelab(node=80, label="Eucentropogonids", family="Helvetica", fontface="plain", offset=3.54) +
  geom_cladelab(node=94, label="andinus clade", family="Helvetica", fontface="plain", offset=3.27) +
  geom_cladelab(node=103, label="Colombianids", family="Helvetica", fontface="plain", offset=4.05)
t2
#dev.off()

ggsave(plot = t2, filename = "SISRS_marker_Camp_wastral.png", width = 15, height = 15, units = "in", limitsize = FALSE)
