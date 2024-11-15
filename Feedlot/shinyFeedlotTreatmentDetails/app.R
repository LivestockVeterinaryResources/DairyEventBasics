#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinyWidgets)
library(tidyverse)

#Treatments--------------
tx<-read_rds('tx.rds') #for deploy
#tx<-read_rds('shinyFeedlotTreatmentDetails/tx.rds') #for test

#Animals-----------------------------
animals<-read_rds('animals.rds')
#animals<-read_rds('shinyFeedlotTreatmentDetails/animals.rds')

levels_tx<-c("B12", "THIAMINE", "DEXAMETHASONE", "IV","LA 200","Micotil", 
             "PENICILLIN","EXCENEL","BAYTRIL", "NUFLOR", "DRAXXIN"
)

colors_drug<-c("THIAMINE" = 'yellow',
               "B12" = 'purple', 
               "DEXAMETHASONE" = 'grey20', 
               "IV" = 'grey40',
               "LA 200" = 'magenta', 
               "Micotil" = '#6baed6',
               "PENICILLIN" = '#3182bd',  
               "EXCENEL" = '#08519c', 
               "BAYTRIL" = '#fd8d3c', 
               "NUFLOR" = '#d95f02', 
               "DRAXXIN" = '#a63603')

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Explore Treatment Details"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          numericInput("set_gap", 
                       "Choose Treatment Gap Setting (days)", 
                       3),
          pickerInput(
            inputId = "set_animal",
            label = "Select Animal by Tag Number",
            choices = sort(unique(tx$tag)),
            selected = c(seq(33143,33155, by = 1)),
            multiple = TRUE,
            options = list(`actions-box` = TRUE)
          )
        ),
        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           plotOutput('plot')
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  treats<-reactive({
    tx%>%
      group_by(tag, eid, Date)%>%
      summarize(Diagnosis = paste0(sort(unique(Diagnosis)), collapse = ' '), 
                Protocols = paste0(Protocol, collapse = ' '), 
                Protocols_simple = paste0(sort(unique(Protocol)), collapse = ' ')
      )%>%
      ungroup()%>%
      group_by(tag, eid)%>%
      arrange(Date)%>%
      mutate(touch_ct = 1:n())%>%
      mutate(gap_date = lag(Date))%>%
      ungroup()%>%
      mutate(gap_days =as.numeric(Date-gap_date))%>%
      rowid_to_column()%>%
      mutate(reg_id = case_when(
        (is.na(gap_days))~paste0('R', rowid), 
        (gap_days<input$set_gap)~as.character(NA), 
        (gap_days>=input$set_gap)~paste0('R', rowid), 
        TRUE~'ERROR'
      ))%>%
      arrange(tag, eid, Date)%>%
      fill(reg_id)%>%
      left_join(animals)
    
  })
  
  therapy<-reactive({
    treats()%>%
      group_by(tag, eid, reg_id)%>%
      summarize(date_tx_start = min(Date), 
                date_tx_end = max(Date), 
                Protocols = paste0(Protocols, collapse = ' '), 
                Protocols_simple = paste0(sort(unique(Protocols_simple)), collapse = ' : '),
                touch_ct = max(touch_ct), 
                dates_touched = n_distinct(Date))%>%
      ungroup()%>%
      mutate(days_bothered = as.numeric(date_tx_end-date_tx_start))%>%
      group_by(tag, eid)%>%
      arrange(date_tx_start)%>%
      mutate(pull_ct = 1:n())%>%
      ungroup()%>%
      left_join(animals)
  })

    output$distPlot <- renderPlot({
      ggplot(tx%>%
               filter(tag %in% input$set_animal)%>%
               mutate(Protocol = factor(Protocol, levels = levels_tx))
      )+
        geom_point(aes(x = Date, y = Protocol, color = Protocol), size = 5, shape = 16)+
        theme_bw()+
        theme(legend.position = 'left')+
        facet_grid(tag~., scales = 'free_y')+
        scale_color_manual(values = colors_drug)+
        labs(title = 'Individual Drug Treatments')
    })
    
    output$plot <- renderPlot({
      ggplot(therapy()%>%
               filter(tag %in% input$set_animal)%>%
               mutate(Therapy = case_when(
                 (str_count(Protocols_simple)>35)~'Many Treatments', 
                 TRUE~Protocols_simple)
               )
      )+
        geom_linerange(aes(xmin = date_tx_start, xmax = date_tx_end, y = Therapy), linewidth = 3)+
        geom_point(aes(x = date_tx_start,  y = Therapy), size = 5)+
        theme_bw()+
        facet_grid(tag~., scales = 'free')+
        labs(title = 'Therapy Durations')+
        xlab('Date')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
