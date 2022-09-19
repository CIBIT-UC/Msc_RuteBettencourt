# cLear workspace
rm(list = ls())

# import required packages
library("plyr")
library("dplyr")
library("ggpubr")
library("car")
library("R.matlab")
library("sjlabelled")
library("plotly")
#library("xlsx")
#library("tidyverse")
library(rstatix)

# Import data from matlab
setwd("/Users/alexandresayal/GitHub/Msc_RuteBettencourt/Dynamic Connectivity")
matlabFile = readMat("outputForR/Insula_right--V3A_bilateral.mat")

#setwd("/Users/alexandresayal/GitHub/Msc_RuteBettencourt/VOI_analysis")
#matlabFile = readMat("outputForR/SS_FEF--SS_hMT.mat")

# Select algorithm
my_data1 = as.data.frame(matlabFile)

labels = c("Effect","Time","spearmanC")
colnames(my_data1) = labels

# Transform variable types to factors
my_data1$Effect = factor(my_data1$Effect,
                      levels = c(1,2),
                      labels = c("NegativeHyst","PositiveHyst"))
my_data1$Time = factor(my_data1$Time,
                    levels = c(1,2,3),
                    labels = c("Pre","EffectB","Post"))

# Summary stats
my_data1 %>%
  group_by(Time, Effect) %>%
  get_summary_stats(spearmanC, type = "mean_sd")

# Line plots with multiple groups
ggboxplot(my_data1,
             x = "Time",
             y = "spearmanC",
             color = "Effect",
             palette = "simpsons",
             xlab = "",
             ylab = "",
             add = c("mean_se"))

# find outliers
my_data1 %>%
  group_by(Time,Effect) %>%
  identify_outliers(spearmanC)

# Normality
my_data1 %>%
  group_by(Time,Effect) %>%
  shapiro_test(spearmanC)

# Two-way ANOVA with interaction effect - timeElapsed
results.aov2 = aov(spearmanC ~ Time * Effect, data = my_data1)

summary(results.aov2)

# Multiple comparison - Tukey - Post-hoc
tukey1 = TukeyHSD(results.aov2,"Time", ordered = TRUE)
tukey1
