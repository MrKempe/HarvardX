# If necessary, install packages
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")
if(!require(stringr)) install.packages("stringr", repos = "http://cran.us.r-project.org")

# Load packages
library(tidyverse)
library(caret)
library(stringr)

# Download & Unzip MovieLens files
url <- "http://files.grouplens.org/datasets/movielens/ml-10m.zip"
tmp_file <- tempfile()
download.file(url, tmp_file)
movies_raw <- readLines(unzip(tmp_file, "ml-10M100K/movies.dat"))
ratings_raw <- readLines(unzip(tmp_file, "ml-10M100K/ratings.dat"))
file.remove(tmp_file)

# Data Wrangling - Movies
movies <- data.frame(str_split_fixed(movies_raw,"::", 3))
colnames(movies) <- c("MovieID", "Title", "Genres")
movies <- mutate(movies, MovieID = as.integer(levels(MovieID))[MovieID], 
                 Title = as.character(Title),
                 Genres = Genres)

# Data Wrangling - Ratings
ratings <- data.frame(str_split_fixed(ratings_raw, "::", 4))
colnames(ratings) <- c("UserID", "MovieID", "Rating", "Timestamp")
ratings <- mutate(ratings, UserID = as.integer(levels(UserID))[UserID],
                  MovieID = as.integer(levels(MovieID))[MovieID],
                  Rating = as.numeric(levels(Rating))[Rating],
                  Timestamp = as.integer(levels(Timestamp))[Timestamp])

# Combine Movies & Ratings
movie_db <- left_join(ratings, movies, by = "MovieID")  

