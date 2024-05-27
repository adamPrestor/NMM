# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)

# working directory
setwd("C:/Mag/NMM/R/Results")

# load values
df_model <- data.frame(fread("stability/model.csv", sep = ",", header = FALSE))
names(df_model) <- c("weight")
df_model$type <- "Our model"
df_model$index <- seq(2000)

df <- df_model

df <- data.frame()

for (n_d in seq(10, 190, 10)) {
	file_name <- sprintf("stability/model_%d.csv", n_d)
	df_nd <- data.frame(fread(file_name, sep = ",", header = FALSE))
	names(df_nd) <- c("weight")
	df_nd$type <- sprintf("Model %d", n_d)
	df_nd$index <- seq(2000)

	df <- rbind(df, df_nd)
}

palette <- c(
  "dodgerblue2", "#E31A1C", # red
  "green4",
  "#6A3D9A", # purple
  "#FF7F00", # orange
  "black", "gold1",
  "skyblue2", "#FB9A99", # lt pink
  "palegreen2",
  "#CAB2D6", # lt purple
  "#FDBF6F", # lt orange
  "gray70", "khaki2",
  "maroon", "orchid1", "deeppink1", "blue1", "steelblue4",
  "darkturquoise", "green1", "yellow4", "yellow3",
  "darkorange4", "brown"
)

ggplot(df, aes(x = index, y = weight, colour = type)) +
  geom_line(size = 1) +
  theme_minimal() +
  labs(x = "Time", y = "Connection weight") +
  scale_colour_manual(values = palette) +
  theme(legend.title = element_blank(), text = element_text(size = 18)) +
  ylim(0, 1)
