# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)

# working directory
setwd("D:/Mag/SourceCode/NMM/R/Results")

# load values
n_ds <- seq(55, 100, by=5)
print(n_ds)
df <- data.frame()
for (n_d in n_ds) {
	df_file <- sprintf("stability/model_%d.csv", n_d)
	df_model <- data.frame(fread(df_file, sep = ",", header = FALSE))
	names(df_model) <- c("weight")
	df_model$type <- sprintf("Steps=%d", n_d)
	df_model$index <- seq(2000)

	df <- rbind(df, df_model)
}

n <- length(n_ds)
palette <- rainbow(n, s = 1, v = 1, start = 0, end = max(1, n - 1)/n, alpha = 1)

ggplot(df, aes(x = index, y = weight, colour = type)) +
  geom_line(size = 1) +
  theme_minimal() +
  labs(x = "Time", y = "Connection weight") +
  scale_colour_manual(values = palette) +
  theme(legend.title = element_blank(), text = element_text(size = 18)) +
  ylim(0, 1)
	