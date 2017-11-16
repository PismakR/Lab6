library(shiny)
shinyUI(fluidPage(
  titlePanel("Text to image converter"),
  sidebarLayout(
    sidebarPanel(
      strong("Settings:"),
      checkboxInput("checkbox3", label = "Document stemming", value = TRUE),
      checkboxInput("checkbox2", label = "Repeatable", value = TRUE),
      sliderInput("slider3", "Rotation:",
                  min = 0.0, max = 1.0, value = 0.35),
      textInput("text", "Text input:"),accept=c("text/plain", ".txt")),
    mainPanel(
      imageOutput("wordcloud"))
  )
))