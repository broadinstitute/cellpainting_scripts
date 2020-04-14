#!/usr/bin/env Rscript

#TODO: Cell Painting channel names are hard coded; make this a parameter.

'convert_path_to_url
Usage:
  convert_path_to_url.R <input> -o <file> [-d <dir>] [-u <url>]
Options:
  -h --help                         Show this screen.
  -o <file> --output=<file>         output CSV file.
  -d <dir> --base_dir=<dir>         base directory in `PathName` field [default: /home/ubuntu/bucket].
  -u <url> --base_url=<url>         base URL in `URL`. [default: https://s3.amazonaws.com/imaging-platform]' -> doc

suppressWarnings(suppressMessages(library(docopt)))

suppressWarnings(suppressMessages(library(dplyr)))

suppressWarnings(suppressMessages(library(magrittr)))

suppressMessages(suppressMessages(library(readr)))

suppressWarnings(suppressMessages(library(stringr)))

suppressMessages(suppressMessages(library(tidyr)))

opts <- docopt(doc)

input <- opts[["input"]]

output <- opts[["output"]]

base_dir <- opts[["base_dir"]]

base_url <- opts[["base_url"]]

to_url <- function(abspath) {
  abspath %>%
  str_replace_all(" ", "+") %>%
    str_replace_all(base_dir, base_url)
}

df <- read_csv(input, col_types = cols())

df %<>%
  unite(URL_OrigDNA, PathName_OrigDNA, FileName_OrigDNA,  sep="/") %>%
  unite(URL_OrigER, PathName_OrigER, FileName_OrigER,  sep="/") %>%
  unite(URL_OrigAGP, PathName_OrigAGP, FileName_OrigAGP,  sep="/") %>%
  unite(URL_OrigMito, PathName_OrigMito, FileName_OrigMito,  sep="/") %>%
  unite(URL_OrigRNA, PathName_OrigRNA, FileName_OrigRNA,  sep="/") %>%
  rowwise() %>%
  mutate(URL_OrigDNA = to_url(URL_OrigDNA)) %>%
  mutate(URL_OrigER = to_url(URL_OrigER)) %>%
  mutate(URL_OrigAGP = to_url(URL_OrigAGP)) %>%
  mutate(URL_OrigMito = to_url(URL_OrigMito)) %>%
  mutate(URL_OrigRNA = to_url(URL_OrigRNA)) %>%
  ungroup()

if ("PathName_IllumDNA" %in% names(df)) {
  df %<>%
    unite(URL_IllumDNA, PathName_IllumDNA, FileName_IllumDNA,  sep="/") %>%
    unite(URL_IllumER, PathName_IllumER, FileName_IllumER,  sep="/") %>%
    unite(URL_IllumAGP, PathName_IllumAGP, FileName_IllumAGP,  sep="/") %>%
    unite(URL_IllumMito, PathName_IllumMito, FileName_IllumMito,  sep="/") %>%
    unite(URL_IllumRNA, PathName_IllumRNA, FileName_IllumRNA,  sep="/") %>%
    rowwise() %>%
    mutate(URL_IllumDNA = to_url(URL_IllumDNA)) %>%
    mutate(URL_IllumER = to_url(URL_IllumER)) %>%
    mutate(URL_IllumAGP = to_url(URL_IllumAGP)) %>%
    mutate(URL_IllumMito = to_url(URL_IllumMito)) %>%
    mutate(URL_IllumRNA = to_url(URL_IllumRNA)) %>%
    ungroup()
}

df %>%
  write_csv(output)
