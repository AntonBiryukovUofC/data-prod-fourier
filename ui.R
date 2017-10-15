#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Fourier Decomp Demo"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width=3,
      sliderInput("freq_num",
                  "Number of frequencies to generate",
                  min = 1,
                  max = 9,
                  value = 3),
      sliderInput("freq_range",
                  "Range of frequencies to generate from [Hz]",
                  min = 1,
                  max = 25,
                  value = c(2.5,25)),
      tags$div(
        h3('Documentation'),
        p(' This little Shiny applet demonstrates the concept of Fourier decomposition.
            Roughly speaking, the theory assumes any periodic continuous signal can be 
            decomposed into an infinite sum of harmonics (i.e. harmonic = A*sin(2*pi*f*t + phi)),
            where A is the amplitude of the harmonic, f - its frequency, and phi - its phase shift'),
        p('Fourier transform and the amplitude spectrum help us find the strongest harmonics,
          and their relative contribution to the signal. Amplitude spectrum of a signal that is
          a sum of two sinusoids of 2 Hz and 10 Hz will have peaks at 2 and 10 Hz, and will be flat otherwise'),
        p('Here you are given a chance to visualize this concept. In this exercise you create a signal
          first from a known set of N harmonics - N is specified with the first slider. 
          The frequencies are then drawn randomly from the range you specify with the second slider'),
        p('The top plot will show a full signal, that is a sum of harmonics shown in the middle plot.
          The bottom picture shows the corresponding Fourier Amplitude spectrum with the true 
          frequencies indicated as red vertical lines. The strength of the peak indicates the 
          relative contribution of that harmonic to the full signal.')
        
      )
      
      
    ),
 
    
    # Show a plot of the generated distribution
    mainPanel(
      h2('Full signal'),
      h4('signal = sum of components'),
      plotOutput("fullsigPlot",height=250),
      h2('Components'),
      plotOutput("sigPlot",height=250),
      h3('Amplitude spectrum'),
      plotOutput("spectrumPlot",height=250)
       
    )
  )
  
  )
)


