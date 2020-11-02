#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Rohan Alexander and Sam Caetano [CHANGE THIS TO YOUR NAME!!!!]
# Data: 22 October 2020
# Contact: rohan.alexander@utoronto.ca [PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data.
setwd("~/Desktop/304_PS3")
raw_data <- read_dta("usa_00002.dta")


# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
reduced_data <- 
  raw_data %>% 
  select(
         #stateicp,
         sex, 
         age, citizen, region)
         #race, 
         #hispan,
         #marst, 
         #bpl,
         #educd,
         #labforce,
         #labforce)
reduced_data <- 
  raw_data %>%
  filter(citizen != "n/a")%>%
  filter(citizen != "not a citizen")


         

#### What's next? ####

## Here I am only splitting cells by age, but you 
## can use other variables to split by changing
## count(age) to count(age, sex, ....)
reduced_data <- reduced_data %>%
  rename(gender = sex) %>%
  mutate(gender = ifelse(gender == "male", "Male", "Female")) %>%
  rename(census_region = region) 
reduced_data$census_region <- recode(reduced_data$census_region,
                                        "east north central div"="Midwest", 
                                        "west north central div"="Midwest", 
                                        "south atlantic division"="South", 
                                        "east south central div"="South", 
                                        "west south central div"="South", 
                                        "pacific division"="West", 
                                        "mountain division"="West", 
                                        "new england division"="Northeast", 
                                        "middle atlantic division"="Northeast")
reduced_data <- 
  reduced_data %>%
  count(age, gender, census_region) %>%
  group_by(age, gender, census_region) 

reduced_data <- 
  reduced_data %>% 
  filter(age != "less than 1 year old") %>%
  filter(age != "90 (90+ in 1980 and 1990)") 
 
  


reduced_data$age <- as.integer(reduced_data$age)

# Saving the census data as a csv file in my
# working directory
write_csv(reduced_data, "census_data.csv")



         