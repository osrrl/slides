## @knitr loadClean

# clean working directory
rm(list = ls(all = TRUE))

# Set working directory
# setwd("~/Desktop/percepcion_categorica/")

# load packages
library(plyr); library(tidyr); library(dplyr); 
library(ggplot2); library(pander); library(xtable)

# Combine files vertically into large data frame
temp <- list.files(path = "./2AFC/data/", full.names = TRUE, pattern = ".csv")
myfiles = lapply(temp, read.csv, sep = ",", header = FALSE, skip = 5)
df <- do.call("rbind", myfiles)

df %>%
  select(., stim = V1, response = V10, rt = V11, participant = V16) ->
  df

# change stim name; set as numeric
df$stim <- substr(df$stim, start = 19, stop = 21)
df$stim <- as.numeric(df$stim)

# change responses to numerics
df$response <- as.character(df$response)
df[df$response == "left", "response"] <- 1
df[df$response == "right", "response"] <- 0
df$response <- as.numeric(df$response)


glimpse(df)




### Descriptives

## @knitr table1

df %>%
  aggregate(response ~ stim, data = ., FUN = mean) %>%
  xtable(caption = "", digits = c(1, 0, 2)) %>%
  print(., type = 'html', include.rownames=FALSE)

## @knitr table2

df %>%
  aggregate(rt ~ stim, data = ., FUN = mean) %>%
  xtable(caption = "", digits = c(1, 0, 3)) %>%
  print(., type = 'html', include.rownames=FALSE)








### plots

## @knitr responsePlot

df %>%
  group_by(participant, stim) %>%
  summarize(prop = mean(response)) %>%
  ggplot(., aes(x = stim, y = prop)) + 
  stat_summary(fun.y = mean, geom = 'line', colour = 'grey') +
  stat_summary(fun.data = mean_cl_boot, geom = 'errorbar', width = 1, colour = 'red') +
  stat_summary(fun.y = mean, geom = 'point', size = 0.75) +
  scale_y_continuous(limits = c(-0.1, 1.1), breaks = c(0, 0.5, 1), labels = c("pa", "50%", "ba")) +
  ylab("Response") + xlab("VOT (ms)") + 
  scale_x_continuous(breaks = seq(from = -60, to = 60, by = 10), labels = seq(from = -60, to = 60, by = 10)) +
  theme_bw(base_size = 20, base_family = "Times New Roman") +
  theme(legend.position = "right", legend.background = element_rect(fill = "transparent"))


## @knitr responseMod

df %>%
  ggplot(., aes(x = stim, y = response)) + 
  geom_smooth(method = "glm", method.args=list(family="binomial"), lwd = 0.75) +
  scale_y_continuous(breaks = c(0, 0.5, 1), labels = c("pa", "50%", "ba")) +
  ylab("Response") + xlab("VOT (ms)") + 
  scale_x_continuous(breaks = seq(from = -60, to = 60, by = 10), labels = seq(from = -60, to = 60, by = 10)) +
  theme_bw(base_size = 20) +
  theme(legend.position = c(0.11, 0.89), legend.background = element_rect(fill = "transparent"))

## @knitr rtPlot

df %>%
  aggregate(rt ~ stim + participant, data = ., FUN = mean) %>%
  ggplot(., aes(x = stim, y = rt)) + 
  geom_jitter(size = 1.15) +
  ylim(0, 1) + 
  geom_smooth(lwd = 0.85) +
  ylab("RT (ms)") + xlab("VOT (ms)") + 
  scale_x_continuous(breaks = seq(from = -60, to = 60, by = 10), labels = seq(from = -60, to = 60, by = 10)) +
  theme_bw(base_size = 20) +
  theme(legend.position = c(0.11, 0.89), legend.background = element_rect(fill = "transparent"))






