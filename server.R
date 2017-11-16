library(shiny)
library(wordcloud)
library(tm)
library(SnowballC)
shinyServer(function(input, output) {
  datainput <- reactive({
    validate(
      need((input$text != "") || (!is.null(input$file)),
           "Write Text!"
      )
    )
    if (nchar(input$text) > 0){
      words <- Corpus(VectorSource(input$text))
    }
    else if (!is.null(input$file)){
      a <- input$file$datapath
      a <- substr(a, 1, nchar(a) - 1)
      words <- Corpus(DirSource(a))
    }
    words <- tm_map(words, stripWhitespace)
    words <- tm_map(words, content_transformer(tolower))
    words <- tm_map(words, removeWords, stopwords("SMART"))
    words <- tm_map(words, removeNumbers)
    words <- tm_map(words, removePunctuation)
  })
  finalinput <- reactive({
    if (input$checkbox3) datainput <- tm_map(datainput(), stemDocument)
    datainput()
  })
  asdas <- reactive({
    if (input$checkbox2) wordcloud_rep <- repeatable(wordcloud)
    else wordcloud_rep <- wordcloud
  })
  make_cloud <- reactive ({
    wordcloud_rep <- asdas()
    png("image.png", width=10, height=8, units="in", res=350)
    w <- wordcloud_rep(finalinput(),
                       scale=c(5, 0.5),
                       min.freq=1,
                       max.words=1000,
                       random.order=FALSE,
                       rot.per=input$slider3,
                       use.r.layout=FALSE,
                       colors=brewer.pal(8, "Dark2"))
    dev.off()
    filename <- "image.png"
  })
  output$wordcloud <- renderImage({
    list(src=make_cloud(), alt="Image generated!", height=600)
  },
  deleteFile = FALSE)
})