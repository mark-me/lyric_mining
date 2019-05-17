df_artist_lyrics <- df_lyrics %>% 
  filter(!is.na(lyric)) %>% 
  group_by(artist) %>% 
  summarise(lyric = paste0(lyric, collapse = " ")) %>% 
  ungroup() %>% 
  mutate(doc_id = row_number()) %>% 
  dplyr::select(doc_id, text = lyric, everything())

# Make factor of artists for modelling
levels_artists <- unique(df_artist_lyrics$artist)
df_artist_lyrics$artist <- factor(df_artist_lyrics$artist, levels = levels_artists)

# Convert df_source to a corpus: df_corpus
corpus_artist_lyrics <- Corpus(VectorSource(df_artist_lyrics$text))

# Clean corpus
corpus_artist_lyrics %<>% 
  tm_map(removeWords, c("-", "—","“", "‘","…", "NA", "character")) %>% 
  tm_map(content_transformer(tolower)) %>% 
  tm_map(content_transformer(removeNumbers)) %>% 
  tm_map(content_transformer(removePunctuation)) %>% 
  tm_map(removeWords, stopwords("english")) %>% 
  tm_map(content_transformer(stripWhitespace))

tdm_lyrics <- TermDocumentMatrix(corpus_lyrics)

tdm_lyrics = as.matrix(tdm_lyrics)
colnames(tdm_lyrics) <- levels_artists

dev.new(width = 1000, height = 1000, unit = "px")
comparison.cloud(tdm_lyrics, random.order=FALSE, 
                 colors =  c("aquamarine","darkgoldenrod","tomato", "aquamarine","darkgoldenrod","tomato"),
                 title.colors =  c("aquamarine","darkgoldenrod","tomato", "aquamarine","darkgoldenrod","tomato"),
                 title.size=1, max.words=300)
