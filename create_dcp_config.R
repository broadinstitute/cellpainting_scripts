#!/usr/bin/env Rscript

'create_dcp_config

Usage: 
  create_dcp_config.R -d <file> -r <file> -a <dir> -p <file> -o <file>

Options:
  -d <file> --data_file=<file>      load_data CSV file.
  -r <file> --groups_file=<file>    groups CSV file.
  -a <dir> --output_dir=<dir>       output directory.
  -p <file> --pipeline=<file>       pipeline file.
  -o <file> --output=<file>         config file.' -> doc

suppressWarnings(suppressMessages(library(docopt)))

suppressWarnings(suppressMessages(library(dplyr)))

suppressWarnings(suppressMessages(library(magrittr)))

suppressWarnings(suppressMessages(library(readr)))

suppressWarnings(suppressMessages(library(tidyr)))

opts <- docopt(doc)

data_file <- opts[["data_file"]]

groups_file <- opts[["groups_file"]]

output_dir <- opts[["output_dir"]]

output <- opts[["output"]]

pipeline <- opts[["pipeline"]]

suppressWarnings(suppressMessages(groupings <- read_csv(groups_file)))

group_tags <- names(groupings)

for (group_tag in group_tags) {
  groupings[paste0(group_tag, "_tag")] <- group_tag
  groupings %<>% unite_(paste0(group_tag, "_new"), c(paste0(group_tag, "_tag"), group_tag), sep = "=")
}

groupings %<>% unite_("Metadata", paste(group_tags, "new", sep = "_"), sep = ",")

list(
  "pipeline" = pipeline, 
  "data_file" = data_file, 
  "input" = "dummy",
  "output" = output_dir,        
  "groups" = groupings
) %>% jsonlite::toJSON(pretty = T, auto_unbox = T) %>% write_file(output)

