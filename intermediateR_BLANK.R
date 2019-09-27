# ---- Set Working Directory ----


# ---- Load Packages ----
library(tidyr)
library(dplyr)
library(forcats)
library(ggplot2)
library(ggalluvial)
library(ggmosaic)

# ---- Import Data ----
# Import .txt files (working_data and park_details)

## Take a few minutes to explore these two data frames with a partner
# or in a small group.
## How are the data structured?

# ---- Explore Data ----
  # Number of rows and columns

  # First six rows
  # Last six rows

  # Column names

  # summarise each column

  # View the structure of the data frame
  # View the structure of the data frame using dplyr

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


# dplyr::filter() : filters rows from a data frame

# Goal: Display amphibian data from Arches National Park


# %>%      : a pipe, used to create a workflow
# Information is passed through a pipe, then used as the first argument
# for the function on the other side




# Pipes are valuable when we want to perform multiple steps

# Goal: Display park name, latitude, and longitude from parks in Hawaii


# dplyr::group_by() : splits your data into groups based on the variables you specify

# Goal: group the parks data by state


# dplyr::summarise() : returns a statistic (from each group, if applicable)

# Goal: Create a summary table with the average park size, by state


# We can store this as an object



## Goal: Create a summary table of the average latitide, by state, of parks that
# are greater than 100,000 acres and store it in an object called mytable



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

## What needs to change before we can combine these data frames?


# ---- Change Names to Lower Case ----
# dplyr::rename_all() : rename all of the columns based on a function
# see also: {janitor} for more options


# ---- Unite records and id ----
# Goal: We want a column called record.id that contains
# record and id, separated with a "-"

# Option 1: base::paste()

## Why does this create more work for us?

# Option 2: tidyr::unite() : unite two columns to create one new one in its place


# ---- Fill in the Blanks ----
# In the order and family columns, the NAs should actually be filled in based on
# the previous values


# tidyr::fill() : fills missing values in a column using the previous entry


# ---- Reevaluate Data Frame ----
## Do you think these can be combined now?


# dplyr::bind_rows() : bind data frames by row (i.e. stacked)


# dplyr::mutate_if() : if a column meets some criteria, apply a function to the column


# ---- Redwood National Park Data ----
# Import data (REDW_records and REDW_species)

## Take a few minutes to explore these two data frames with a partner
# or in a small group.
## How are the data structured?
## Can this data be combined with the larger data set?
## What are some problems?
## What steps would you take to achieve this?

# ---- Reshaping Data ----

# tidyr::gather() : convert from wide to long format

# Goal: Convert redwood_records from wide to long



# tidyr::drop_na() : drop all rows that contain any NAs


# ---- Separate oasr ----
# oasr represents occurrence, abundance, seasonality, and report.status


# tidyr::separate() : separate a string from one column into multipl columns

# Always test these processes before overwriting the object!


# Overwrite object

## What is wrong with this data?

# Option 1: Replace these using base::ifelse()


# Option 1a: Do this for all three columns individually


# Option 2: Use na_if(), a built-in dplyr function for doing exactly this
# dplyr:;na_if() : if a value matches the given value, change it to NA


# Option 2a: Use this on all three columns individually


# Option 2b: Specify that it should be used on any column that is a character vector


# dplyr::mutate_if() : if a column meets some criteria, apply a function to the column


# Option 3: If this function didn't exist: create your own!


# Option 3a: Apply to each column individually


# Option 3b: Specify that it should be used on any column that is a character vector


# Option 3c: Build the function inside mutate_if


# Overwrite existing object to make the change permanent


# ---- Joining Data Frames(?) ----
# Eventually we want to be able to combine the information from 
# redwood_long and redwood_species


## What variable will be used to "match" records?
## Does anything else need to change for that to happen?
# Note: We'll use a technique where the order of the rows doesn't matter

# ---- Remove . in scientific names ----
# scientific.name in redwood_long has . instead of spaces

# base:;gsub() : search for a pattern in a string and replace it

# Goal: Replace all "x" in our string with "y"

# Goal: Replace all "REDW" in our record.id column with "THIS IS A TEST"


# Goal: Replace all "." in our scientific.name column with " "
# Does anyone happen to know why this doesn't work? (It's a *very* tricky reason!)


# Solution:


# To learn more about regular expressions: https://r4ds.had.co.nz/strings.html

# Overwrite existing object


# ---- Joining Data Frames ----

# dplyr::left_join(x, y) : return all rows from x and all columns from x and y
# match each row based on values in corresponding columns

# ---- Combining Data Frames ----


# Goal: Combine data2 and redwood_complete by rows
# Problem: Columns aren't in the same order... but that's ok!
# bind_rows() doesn't rely on column being in the same order, just having the same names


# ---- Joining Park Data ----


# Goal: Join the park data from each record


# ---- Convert Characters to Factors ----
## Convert all character vectors back to factors


# ---- Communicating Patterns ----
## Our focus was on amphibians so subset the data to only look at these records


## Potential research questions:
# How many families of amphibians are represented in the data?

# Which states have the highest richness of amphibians in national parks?

# In these states, how are these records distributed across parks? Across taxons?
# What does the distribution of native and non-native specis look like?

# ---- Question 1 ----
## How many families of amphibians are represented in the data?


# ---- Question 2 ----
## Which states have the highest richness of amphibians in national parks?
## Create a summary table of richness (i.e. the number of distinct scientific.names)
# of amphibians present in each state
# Hint: n_distinct()

# Goal: Identify the three states with the greatest richness
# dplyr::arrange() : arrange a data frame by a variable
# dplyr::arrange(desc()) : ...in descending order


# dplyr::slice() : extract specific rows from a data frame


# dplyr::pull() : pull the values from a column as a vector



# Goal: Subset the data to only look at these states


# Goal: Let's save computational power by dropping all of the un-used factor levels


# ---- Question 3 ----
# In these states, how are these records distributed across states? parks?
# taxons? What does the distribution of native and non-native specis look like?

# Goal: Create a subset summarising these points

## What are the pros and cons of this table?

# ---- Visualizing the Data ----
## Goal: Boxplot of number of species per state

# Overlay points

# Overlay jittered points

# Alternative to boxplots: violin plots

# Goal: Boxplot of number of species by nativeness

## How could we combine these plots?


# Mosaic plot (from {ggmosaic})

# A nicer example: state vs order

# ---- Alluvial Plots ----
## What is an alluvial plot?

# {ggalluvial} provides this functionality

# Building up an alluvial plot

# Basic components


# Add vertical stratum


# Add labels to the stratum


# Add x axis labels


# Fill the swaths based on nativeness


# Add order as a third stratum


# At this resolution, it would be better if we collapsed our table to omit family


# Look at how the plot changes


# It would be easier to read if the parks were arranged by state
# forcats::fct_inorder() : reorders factor levels by first appearance  
# Make sure the rows of the data frame are in the right order


# Refactor state

## Why do you think state was already in the "correct" order?

# Refactor park.code

## Why was park.code not in the "correct" order?

# Look at how the plot changes


# Now that we know there are no unused levels, we can outline each swath in black



## How does this compare to states with very few species of amphibians?