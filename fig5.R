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

data <- read.table("tree_metadata.txt", header=T)
data2 <- data %>% mutate(NewLab = ifelse(Species== "sp.", glue("italic({Genus})~{Species}~{Sample}~{Info}"), ifelse(Info=="n.a.", glue("italic({Genus}~{Species})~{Sample}"), glue("italic({Genus}~{Species})~{Sample}~{Info}"))))

col <- c("Burmeistera" = "lightseagreen", "Centropogon" = "plum3", "Lysipomia" = "darkgoldenrod1", "Siphocampylus" = "royalblue3")


tree <- read.tree("/project/pi_rsschwartz_uri_edu/andromeda_transfer/rachel/Campanulaceae_markers/hybpiper_SISRSmarkers/SISRS_marker_Camp.tre")
rooted_tree <- root(tree, outgroup="Lysipomia_vitreola_A217_Antonellii6B", resolve.root = TRUE, edgelabel = TRUE)
rooted_tree$edge.length[which(is.na(rooted_tree$edge.length))] <- 0


t <- ggtree(rooted_tree, layout="rectangular", size=1) + #geom_treescale(x=0, y=78) + 
  xlim(0, 11) + #how much space on left and right
  annotate("point", x=0, y=75, shape=21, fill="darkgray", color="black", size=3) + 
  annotate("text", x=0.1, y=75, label = "> 75% node support", hjust = "left") + 
  geom_nodepoint(aes(subset = !is.na(as.numeric(label)) & as.numeric(label) > 0.75), size=3, shape=21, fill="darkgray", color="black")
t2 <- t %<+% data2 + geom_tippoint(aes(color=factor(Genus)), shape=19, size=2.5) + theme(legend.position = "none") + 
  geom_tiplab(aes(label=NewLab), align=FALSE, hjust=-.02, parse=T, family="Helvetica") + aes(color=factor(Genus)) + scale_color_manual(values = col, name="Genus", na.value="black")


ggsave(plot = t2, filename = "SISRS_marker_Camp_wastral.pdf", width = 26, height = 36, units = "cm", limitsize = FALSE)
