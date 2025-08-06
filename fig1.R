library(tidyverse)

opt <- read.csv('Bur_optimize_markers.tsv', sep = ' ')

opt <- opt %>% separate_wider_delim(ALIGNMENT_INFO, '_m', names = c('old', 'm')) %>%
  separate_wider_delim('m', '.', names = c('m','txt')) %>% select(-old, -txt, -num_contigs)

opt <- opt %>% mutate(avg_var = num_pi_sites/contig_length) %>% pivot_longer(4:8)
opt$m <- factor(opt$m, levels=unique(opt$m))

# New facet label names
new.labs <- c("Variability per site", "Locus length", "Number of loci", "Number of informative sites")
names(new.labs) <- opt %>% filter(name != 'SISRS_sites') %>% pull(name) %>% unique() %>% sort()

opt %>% filter(name != 'SISRS_sites') %>% ggplot(aes(factor(THRESHOLD), value, color = m)) + 
  geom_point(aes(shape=factor(NUM_MISS), size = 3))+
  facet_wrap(~name, scales = "free", labeller = labeller(name = new.labs)) +
  labs(x = "Minimum number of variable sites per locus", y = "", color = "missing species in site alignment", shape = "missing species in locus") +
  theme(axis.text.x = element_text(size = 11), strip.text = element_text(size = 12), 
        axis.title.x = element_text(size = 12), axis.text.y = element_text(size = 11),
        legend.position="bottom", legend.box = "vertical") + 
  guides(size = FALSE)

ggsave("optimized_data_info.jpg", width = 6.5, height = 4.5, units = "in")
