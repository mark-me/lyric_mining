# define preprocessing function and tokenization function
prep_fun <- tolower
tok_fun <- word_tokenizer

it_train <- itoken(df_train$text,
                   preprocessor = prep_fun,
                   tokenizer = tok_fun,
                   ids = df_train$doc_id,
                   progressbar = FALSE)
vocab <- create_vocabulary(it_train, stopwords = stopwords("english"))

# Prune vocabulary: removing uncommon words in few documents and words which are overrepresented in documents
vocab <- prune_vocabulary(vocab,
                          term_count_min = 10,
                          doc_proportion_max = 0.5,
                          doc_proportion_min = 0.001)

# Transform tokens into vector space - i.e. how to map words to indices
vectorizer = vocab_vectorizer(vocab)

# create document-term matrix
dtm_train = create_dtm(it_train, vocab)

df_dtm_train <- as.tibble(as.matrix(dtm_train))
df_dtm_train$artist <- df_lyric_dox$artist[train_ids]