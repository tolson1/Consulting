# Create inital training data
dictionary <- scan("dictionary.txt", what="", sep="\n", encoding = "UTF-8")
set.seed(17)
classes <- c("Public", "Personal")
labels <- sample(classes, 15, replace = TRUE)
for(i in 1:15) {
    document <- sample(dictionary, 30, replace = TRUE)
    con <- file(paste(labels[i], i, ".txt", sep = ""))
    writeLines(as.character(document), con)
    close(con)
}

# Create testing data once algorithm has been implemented
for(j in 1:3) {
    document <- sample(dictionary, 30, replace = TRUE)
    con <- file(paste("unknown", j, ".txt", sep = ""))
    writeLines(as.character(document), con)
    close(con)
}

# Confirm hashmap contains correct counts
files <- list.files()
data <- c();
for (f in files) {
    tempData <- scan(f, what = "character")
    data <- c(data, tempData)
}
table(data)
