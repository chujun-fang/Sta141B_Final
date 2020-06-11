library(shiny)
library(RCurl)

baseurl <- "https://api.lyrics.ovh/v1/"

ui <- navbarPage(
    
    titlePanel("Lyrics of a song"),
    tabPanel(h6("Welcome"),
             
             mainPanel(
                 
                 verbatimTextOutput("welcome"),
                 tags$img(src = 'https://blog.vantagecircle.com/content/images/size/w540h360/2019/09/welcome.png')
                 
                 
             )),
    
    tabPanel(h6("Listen With Me"),
             
             mainPanel(
                 verbatimTextOutput("intro"),
                 HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/2Vv-BfVoq4g" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                 
             )
    ),
    
    tabPanel(h6("Lyrics of a song"),
             sidebarLayout(
                 sidebarPanel(
                     
                     textInput("artist", "artist", "Put the artist of the song. Ex: Lady Gaga"),
                     
                     textInput("title", "title", "Put the name of the song. Ex: 911")
                     
                     
                 ),
                 
                 mainPanel(
                     
                     verbatimTextOutput("lyrics")
                     
                 ))
    )
)

server <- function(input, output, session) {
    
    url <- reactive({
        
        url <- paste0(baseurl, input$artist, "/", input$title)
        URLencode(url)
    })
    
    output$welcome <- renderPrint({
        cat("Welcome to my App!
    \nThis App is designed for finding lyrics of songs.
    \nIn the tab of Lyrics of a Song, you will be ask to provide the name of the artist
    and the title of the song in order to get the lyrics of the song. 
    \nI hope this App is useful for you to find the lyrics of your favorite songs.")
        
    })
    
    
    output$intro <- renderPrint({
        
        cat("Belowe is a favoriate song of mine which is called Perfect by artist Ed Sheeren.
        \n You can also use this App to search for its beautiful lyrics. 
        \nPlease take time to listen and enjoy this song with me.
        \nWish you a good day.")
    })
    
    output$lyrics <- renderPrint ({
        
        
        res <-  getURL(url())
        
        if(grepl("error",res) ) {
            
            cat("Please check your inputs! No such song of the artist founded!")
            
        } else {
            
            
            n <- nchar(res)
            #extract only lyrics
            res2 <- substr(res, 12, n-2)
            res2 <- gsub("\\\\n","\n",res2)
            res2 <- gsub("\\\\r","\r",res2)
            cat(res2)
            
        }
        
        
        
        
    })
    
}

shinyApp(ui = ui, server = server)
