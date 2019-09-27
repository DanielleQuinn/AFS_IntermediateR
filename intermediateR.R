# ---- Set Working Directory ----
setwd("C:/Users/Danielle/Desktop/AFS_IntermediateR")

# ---- Load Packages ----
library(tidyr)
library(dplyr)
library(forcats)
library(ggplot2)
library(ggalluvial)
library(ggmosaic)

# ---- Import Data ----
# Import .txt files
data <- read.delim("working_data.txt")
parks <- read.delim("park_details.txt")

## Take a few minutes to explore these two data frames with a partner
# or in a small group.
## How are the data structured?

# ---- Explore Data ----
dim(data) # Number of rows and columns

head(data) # First six rows
tail(data) # Last six rows

names(data) # Column names

summary(data) # summarise each column

str(data) # View the structure of the data frame
glimpse(data) # View the structure of the data frame using dplyr

# ---- {tidyverse} ----
# The {tidyverse} is a collection of packages that share an
# underlying design philosophy, grammar, and data structures and
# work with "tidy data", which follows specific rules and best practices

# {dplyr}: data manipulation #
# {ggplot2}: visualizing data #
# {lubridate}: working with dates and times 
# {tidyr}: tidying data #
# {broom}: tidying output from models
# {stringr}: working with strings
# {forcats}: working with factors
# {purrr}: functional programming
# {rvset}: web scraping

# https://www.tidyverse.org/packages/

# ---- Review ----
# dplyr::select() : selects columns from a data frame and outputs as a data frame

# Goal: Display the park name and common name columns
select(data, park.name, common.name)

# dplyr::filter() : filters rows from a data frame

# Goal: Display amphibian data from Arches National Park
filter(data, park.name == "Arches National Park",
       category == "Amphibian")

# %>%      : a pipe, used to create a workflow
# Information is passed through a pipe, then used as the first argument
# for the function on the other side

select(parks, park.code)
# is equivalent to
parks %>% select(park.code)

# Pipes are valuable when we want to perform multiple steps

# Goal: Display park name, latitude, and longitude from parks in Hawaii
parks %>%
  filter(state == "HI") %>%
  select(park.name, latitude, longitude)

# dplyr::group_by() : splits your data into groups based on the variables you specify

# Goal: group the parks data by state
parks %>%
  group_by(state)

# dplyr::summarise() : returns a statistic (from each group, if applicable)

# Goal: Create a summary table with the average park size, by state
parks %>%
  group_by(state) %>%
  summarise(average.area = mean(acres))

# We can store this as an object
table1 <- parks %>%
  group_by(state) %>%
  summarise(average.area = mean(acres))

table1

## Goal: Create a summary table of the average latitide, by state, of parks that
# are greater than 100,000 acres and store it in an object called mytable
mytable <- parks %>%
  filter(acres > 100000) %>%
  group_by(state) %>%
  summarise(average.lat = mean(latitude))

mytable

# ---- Tidy Data ----
# These functons work because we're dealing with "tidy" data

# 1. Each row is an observation
# 2. Each column is a variable
# 3. Each cell contains a maximum of one piece of information

# If the data are not in this format, you'll need to reshape it



# ---- Amphibians ----
# We want to synthesize all of the amphibian records from National Parks
# In addition to the tidy data found here, we also have access to

# (a) ACAD.csv : records from Acadia National Park
# (b) REDW_records.txt : incomplete records from Redwood National Park
# (c) REDW_species : species information from Redwood National Park

# Goal: Clean and reshape these files, combine them with our existing data set


# ---- Acadia National Park Data ----
# Import .csv file
acadia <- read.csv("ACAD.csv")

head(acadia)

## What needs to change before we can combine these data frames?


# ---- Change Names to Lower Case ----
# dplyr::rename_all() : rename all of the columns based on a function
# see also: {janitor} for more options

tolower("HELLO")

acadia <- acadia %>% 
  rename_all(tolower)

# ---- Unite records and id ----
# Goal: We want a column called record.id that contains
# record and id, separated with a "-"

# Option 1: base::paste()
paste("a", "b", sep = "-----")

acadia %>%
  mutate(record.id = paste(record, id, sep = "-"))

## Why does this create more work for us?

# Option 2: tidyr::unite() : unite two columns to create one new one in its place
acadia <- acadia %>%
  unite(record.id, c(record, id), sep = "-")

# ---- Fill in the Blanks ----
# In the order and family columns, the NAs should actually be filled in based on
# the previous values
acadia %>% select(order, family)

# tidyr::fill() : fills missing values in a column using the previous entry
acadia <- acadia %>%
  fill(order, family)

# ---- Reevaluate Data Frame ----
head(data, n = 1)
head(acadia, n = 1)

names(data)
names(acadia)

# dplyr::bind_rows() : bind data frames by row (i.e. stacked)
data2 <- bind_rows(data, acadia)

glimpse(data2)

# dplyr::mutate_if() : if a column meets some criteria, apply a function to the column
data2 <- data2 %>%
  mutate_if(is.character, as.factor)

glimpse(data2)

# ---- Redwood National Park Data ----
redwood_records <- read.delim("REDW_records.txt") 
redwood_species <- read.delim("REDW_species.txt")

glimpse(redwood_records)
glimpse(redwood_species)

## Take a few minutes to explore these two data frames with a partner
# or in a small group.
## How are the data structured?
## Can this data be combined with the larger data set?
## What are some problems?
## What steps would you take to achieve this?

# ---- Reshaping Data ----
head(redwood_records)

# tidyr::gather() : convert from wide to long format

# Goal: Convert redwood_records from wide to long
redwood_long <- gather(redwood_records, 
                       key = "scientific.name", 
                       value = "oasr", 
                       -record.id)

glimpse(redwood_long)
head(redwood_long)
View(redwood_long)

# tidyr::drop_na() : drop all rows that contain any NAs
redwood_long <- redwood_long %>%
  drop_na()

head(redwood_long)

# ---- Separate oasr ----
# oasr represents occurrence, abundance, seasonality, and report.status
head(redwood_long)

# tidyr::separate() : separate a string from one column into multipl columns

# Always test these processes before overwriting the object!
redwood_long %>%
  separate(oasr,
           into = c("occurrence", "abundance", "seasonality", "record.status"), 
           sep = '-')

# Overwrite object
redwood_long <- redwood_long %>%
  separate(oasr,
           into = c("occurrence", "abundance", "seasonality", "record.status"), 
           sep = '-')

glimpse(redwood_long)
## What is wrong with this data?

# NAs not being recognized as missing values, instead as the word "NA"
redwood_long$abundance

# Option 1: Replace these using base::ifelse()
ifelse(redwood_long$abundance == "NA", NA, redwood_long$abundance)

# Option 1a: Do this for all three columns individually
redwood_long %>%
  mutate(abundance = ifelse(abundance == "NA", NA, abundance),
         occurrence = ifelse(occurrence == "NA", NA, occurrence),
         record.status = ifelse(record.status == "NA", NA, record.status))

# Option 2: Use na_if(), a built-in dplyr function for doing exactly this
# dplyr:;na_if() : if a value matches the given value, change it to NA
redwood_long$abundance
na_if(redwood_long$abundance, "NA")

# Option 2a: Use this on all three columns individually
redwood_long %>%
  mutate(abundance = na_if(abundance, "NA"),
         occurrence = na_if(occurrence, "NA"),
         record.status = na_if(record.status, "NA"))

# Option 2b: Specify that it should be used on any column that is a character vector
class(redwood_long$abundance)
glimpse(redwood_long)

# dplyr::mutate_if() : if a column meets some criteria, apply a function to the column
redwood_long %>%
  mutate_if(is.character, ~na_if(., "NA"))

# Option 3: If this function didn't exist: create your own!
myfunction <- function(x) {ifelse(x == "NA", NA, x)}
myfunction(c("a", "b", "NA", "d"))

# Option 3a: Apply to each column individually
redwood_long %>%
  mutate(abundance = myfunction(abundance),
         occurrence = myfunction(occurrence),
         record.status = myfunction(record.status))

# Option 3b: Specify that it should be used on any column that is a character vector
redwood_long %>%
  mutate_if(is.character, myfunction)

# Option 3c: Build the function inside mutate_if
redwood_long %>%
  mutate_if(is.character, ~ifelse(. == "NA", NA, .))

# Overwrite existing object to make the change permanent
redwood_long <- redwood_long %>%
  mutate_if(is.character, ~ifelse(. == "NA", NA, .))

glimpse(redwood_long)
head(redwood_long)

# ---- Joining Data Frames(?) ----
# Eventually we want to be able to combine the information from 
# redwood_long and redwood_species

head(redwood_long)
head(redwood_species)

## What variable will be used to "match" records?
## Does anything else need to change for that to happen?
# Note: We'll use a technique where the order of the rows doesn't matter

# ---- Remove . in scientific names ----
# scientific.name in redwood_long has . instead of spaces

# base:;gsub() : search for a pattern in a string and replace it

# Goal: Replace all "x" in our string with "y"
gsub(pattern = "x", replace = "y", "xoxo")

# Goal: Replace all "REDW" in our record.id column with "THIS IS A TEST"
redwood_long %>%
  mutate(record.id = gsub(pattern = "REDW", replace = "THIS IS A TEST", record.id)) %>%
  glimpse()

# Goal: Replace all "." in our scientific.name column with " "
# Does anyone happen to know why this doesn't work? (It's a *very* tricky reason!)
redwood_long %>%
  mutate(scientific.name = gsub(pattern = ".", replace = " ", scientific.name)) %>%
  glimpse()

# Solution:
redwood_long %>%
  mutate(scientific.name = gsub(pattern = "\\.", replace = " ", scientific.name)) %>%
  glimpse()
# To learn more about regular expressions: https://r4ds.had.co.nz/strings.html

# Overwrite existing object
redwood_long <- redwood_long %>%
  mutate(scientific.name = gsub(pattern = "\\.", replace = " ", scientific.name))

# ---- Joining Data Frames ----
head(redwood_long)
head(redwood_species)

# dplyr::left_join(x, y) : return all rows from x and all columns from x and y
# match each row based on values in corresponding columns
redwood_complete <- left_join(redwood_long, redwood_species)

glimpse(redwood_complete)

# ---- Combining Data Frames ----
head(data2, n = 1)
head(redwood_complete, n = 1)

names(data2)
names(redwood_complete)

# Goal: Combine data2 and redwood_complete by rows
# Problem: Columns aren't in the same order... but that's ok!
# bind_rows() doesn't rely on column being in the same order, just having the same names
data_complete <- bind_rows(data2, redwood_complete)
glimpse(data_complete)

# ---- Joining Park Data ----
head(data_complete, n = 1)
head(parks, n = 1)

# Goal: Join the park data from each record
data_complete <- left_join(data_complete, parks)
glimpse(data_complete)

# ---- Convert Characters to Factors ----
## Convert all character vectors back to factors
data_complete <- data_complete %>%
  mutate_if(is.character, as.factor)

# ---- Communicating Patterns ----
# Our focus was on amphibians so subset the data to only look at these records
amp <- data_complete %>%
  filter(category == "Amphibian")

## Potential research questions:
# How many families of amphibians are represented in the data?

# Which states have the highest richness of amphibians in national parks?

# In these states, how are these records distributed across parks? Across taxons?
# What does the distribution of native and non-native specis look like?

# ---- Question 1 ----
## How many families of amphibians are represented in the data?
amp %>%
  summarise(n_distinct(family))

# ---- Question 2 ----
## Which states have the highest richness of amphibians in national parks?
## Create a summary table of richness (i.e. the number of distinct scientific.names)
# of amphibians present in each state
richness_table <- amp %>%
  filter(occurrence == "Present") %>%
  group_by(state) %>%
  summarise(richness = n_distinct(scientific.name))

# Goal: Identify the three states with the greatest richness
# dplyr::arrange() : arrange a data frame by a variable
# dplyr::arrange(desc()) : ...in descending order
richness_table %>%
  arrange(desc(richness))

# dplyr::slice() : extract specific rows from a data frame
richness_table %>%
  arrange(desc(richness)) %>%
  slice(1:3)

# dplyr::pull() : pull the values from a column as a vector
mystates <- richness_table %>%
  arrange(desc(richness)) %>%
  slice(1:3) %>%
  pull(state)

mystates

# Goal: Subset the data to only look at these states
amp_subset <- amp %>%
  filter(state %in% mystates)

levels(amp_subset$state)

# Goal: Let's save computational power by dropping all of the un-used factor levels
amp_subset <- amp_subset %>% droplevels()
levels(amp_subset$state)

# ---- Question 3 ----
# In these states, how are these records distributed across states? parks?
# taxons? What does the distribution of native and non-native specis look like?

# Goal: Create a subset summarising these points
summary_table <- amp_subset %>%
  filter(occurrence == "Present") %>%
  group_by(state, park.code, family, order, nativeness) %>%
  summarise(n = n_distinct(scientific.name)) %>%
  droplevels()

summary_table

## What are the pros and cons of this table?

# ---- Visualizing the Data ----
# Goal: Boxplot of number of species per state
ggplot(summary_table) +
  geom_boxplot(aes(x = state, y = n)) +
  theme_bw()

# Overlay points
ggplot(summary_table) +
  geom_boxplot(aes(x = state, y = n)) +
  geom_point(aes(x = state, y = n)) +
  theme_bw()

# Overlay jittered points
ggplot(summary_table) +
  geom_boxplot(aes(x = state, y = n)) +
  geom_jitter(aes(x = state, y = n), width = 0.25) +
  theme_bw()

# Alternative to boxplots: violin plots
ggplot(summary_table) + 
  geom_violin(aes(x = state, y = n), fill = "red") + 
  geom_boxplot(aes(x = state, y = n), alpha = 0.5) + 
  geom_jitter(aes(x = state, y = n), width = 0.25) +
  theme_bw()

# Goal: Boxplot of number of species by nativeness
ggplot(summary_table) +
  geom_boxplot(aes(x = nativeness, y = n)) +
  theme_bw()

## How could we combine these plots?
ggplot(summary_table) + 
  geom_boxplot(aes(x = state, y = n, fill = nativeness)) + 
  theme_bw()

ggplot(summary_table) + 
  geom_boxplot(aes(x = state, y = n, fill = nativeness)) + 
  theme_bw() +
  facet_wrap(~nativeness, ncol = 1, scales = "free_y")

# Mosaic plot (from {ggmosaic})
ggplot(summary_table) +
  geom_mosaic(aes(weight = n, x = product(state, nativeness), fill = state)) +
  theme_bw()

# A nicer example: state vs order
ggplot(summary_table) +
  geom_mosaic(aes(weight = n, x = product(state, order), fill = state)) +
  theme_bw()

# ---- Alluvial Plots ----
## What is an alluvial plot?

# {ggalluvial} provides this functionality

# Building up an alluvial plot

# Basic components
ggplot(summary_table,
       aes(y = n, axis1 = state, axis2 = park.code)) +
  geom_alluvium() +
  theme_bw()

# Add vertical stratum
ggplot(summary_table,
       aes(y = n, axis1 = state, axis2 = park.code)) +
  geom_alluvium() +
  geom_stratum(width = 1/10) + 
  theme_bw()

# Add labels to the stratum
ggplot(summary_table,
       aes(y = n, axis1 = state, axis2 = park.code)) +
  geom_alluvium() +
  geom_stratum(width = 1/10) +
  geom_label(stat = "stratum", label.strata = TRUE, size = 3) +
  theme_bw()

# Add x axis labels
ggplot(summary_table,
       aes(y = n, axis1 = state, axis2 = park.code)) +
  geom_alluvium() +
  geom_stratum(width = 1/10) +
  geom_label(stat = "stratum", label.strata = TRUE, size = 3) +
  scale_x_discrete(limits = c("State", "Park Code"),
                   expand = c(0.05, 0.05)) +
  theme_bw()

# Fill the swaths based on nativeness
ggplot(summary_table,
       aes(y = n, axis1 = state, axis2 = park.code)) +
  geom_alluvium(aes(fill = nativeness)) +
  geom_stratum(width = 1/10) +
  geom_label(stat = "stratum", label.strata = TRUE, size = 3) +
  scale_x_discrete(limits = c("State", "Park Code"),
                   expand = c(0.05, 0.05)) +
  theme_bw()

# Add order as a third stratum
ggplot(summary_table,
       aes(y = n, axis1 = state, axis2 = park.code, axis3 = order)) +
  geom_alluvium(aes(fill = nativeness)) +
  geom_stratum(width = 1/10) +
  geom_label(stat = "stratum", label.strata = TRUE, size = 3) +
  scale_x_discrete(limits = c("State", "Park Code", "Order"),
                   expand = c(0.05, 0.05)) +
  theme_bw()

# At this resolution, it would be better if we collapsed our table to omit family
summary_table2 <- summary_table %>%
  group_by(state, park.code, order, nativeness) %>%
  summarise(n = sum(n))

# Look at how the plot changes
ggplot(summary_table2,
       aes(y = n, axis1 = state, axis2 = park.code, axis3 = order)) +
  geom_alluvium(aes(fill = nativeness)) +
  geom_stratum(width = 1/10) +
  geom_label(stat = "stratum", label.strata = TRUE, size = 3) +
  scale_x_discrete(limits = c("State", "Park Code", "Order"),
                   expand = c(0.05, 0.05)) +
  theme_bw()

# It would be easier to read if the parks were arranged by state
# forcats::fct_inorder() : reorders factor levels by first appearance  
# Make sure the rows of the data frame are in the right order
summary_table2 <- summary_table2 %>%
  arrange(state, park.code)

# Refactor state
levels(summary_table2$state)
summary_table2$state <- fct_inorder(summary_table2$state)
levels(summary_table2$state)
## Why do you think state was already in the "correct" order?

# Refactor park.code
levels(summary_table2$park.code)
summary_table2$park.code <- fct_inorder(summary_table2$park.code)
levels(summary_table2$park.code)
## Why was park.code not in the "correct" order?

# Look at how the plot changes
ggplot(summary_table2,
       aes(y = n, axis1 = state, axis2 = park.code, axis3 = order)) +
  geom_alluvium(aes(fill = nativeness)) +
  geom_stratum(width = 1/10) +
  geom_label(stat = "stratum", label.strata = TRUE, size = 3) +
  scale_x_discrete(limits = c("State", "Park Code", "Order"),
                   expand = c(0.05, 0.05)) +
  theme_bw()

# Now that we know there are no unused levels, we can outline each swath in black
ggplot(summary_table2,
       aes(y = n, axis1 = state, axis2 = park.code, axis3 = order)) +
  geom_alluvium(aes(fill = nativeness), col = "black") +
  geom_stratum(width = 1/10) +
  geom_label(stat = "stratum", label.strata = TRUE, size = 3) +
  scale_x_discrete(limits = c("State", "Park Code", "Order"),
                   expand = c(0.05, 0.05)) +
  theme_bw()


## How does this compare to states with very few species of amphibians?