# Description -------------------------------------------------------------

# This script uses the unprocessed data to prepare a set of processed data
# that can be shared as open data. The main purpose is to remove sensitive
# information. 

# Code --------------------------------------------------------------------

library(tidyverse)

#  Project Database -------------------------------------------------------

main <- read_csv("data/unprocessed_data/tab-01-supervision-main.csv")
projects <- read_csv("data/unprocessed_data/tab-03-student-project-information.csv")

main_small <- main %>% 
  filter(!str_detect(student_id, "jogwang")) %>% 
  select(student_id:type) 

projects_small <- projects %>% 
  select(student_id, project_title, principles, thematic_area, country)

project_database <- main_small %>% 
  left_join(projects_small) %>% 
  select(-student_id) %>%
  mutate(degree = case_when(
    degree == "msc" ~ "MSc",
    degree == "bsc" ~ "BSc",
    degree == "phd" ~ "PhD",
    degree == "post" ~ "Post Doc"
  )) %>% 
  mutate(type = case_when(
    type == "sem-proj" ~ "Semester Project",
    type == "thesis" ~ "Thesis",
    type == "proj" ~ "Project"
  )) 

write_csv(project_database, "data/processed_data/tbl01-project-database.csv")


