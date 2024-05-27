# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)
library(dplyr)

# working directory
# clear workspace
rm(list = ls())

# load libraries
library(ggplot2)
library(data.table)

# working directory
setwd("C:/Mag/NMM/R/Results")

# load values
df <- data.frame(fread("simulation/M_t_model.csv", sep = ",", header = FALSE))
names(df) <- c("index", "l", "c", "q", "r", "deg")

# phase length
phase <- 500000

ggplot(df, aes(x = index, y = l)) +
  annotate("rect", xmin = 0, xmax = phase, ymin = 0, ymax = Inf, alpha = 0.20, fill = "grey75") +
  annotate("rect", xmin = phase, xmax = 2 * phase, ymin = 0, ymax = Inf, alpha = 0.60, fill = "grey75") +
  geom_line(size = 1, colour = "#beaed4") +
  theme_minimal() +
  theme(text = element_text(size = 18)) +
  labs(x = "Time", y = "Characteristic path") +
  scale_x_continuous(labels = function(x) format(x, scientific = FALSE)) +
  ylim(0, 10)

# load values
df_stability <- data.frame(fread("stability/Stam_extensive.csv", sep = ",", header = FALSE))
names(df_stability) <- c("instability", "a_sdp", "a_gdp")

df_mean <- df_stability %>%
  group_by(a_sdp, a_gdp) %>%
  summarize(mean=mean(instability),
            low=quantile(instability, 0.025),
            high=quantile(instability, 1-0.025))

ggplot(df_mean, aes(y = mean, x = a_sdp)) +
  geom_ribbon(aes(ymin=low, ymax = high), fill="#3182bd", alpha=0.4) +
  geom_line(size = 1, color="#3182bd") +
  theme_minimal() +
  scale_x_continuous(breaks=c(0.0001, 0.0025, 0.005, 0.0075, 0.01),
                     labels=c("0.0001/0.00001",
                              "0.0025/0.00025",
                              "0.005/0.0005",
                              "0.0075/0.00075",
                              "0.01/0.001")) +
  labs(x = expression(a[sdp] / a[gdp]), y = "Instability") +
  theme(legend.title = element_blank(), text = element_text(size = 18)) +
  ylim(0, 1)

  