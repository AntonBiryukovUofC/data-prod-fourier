#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
getSinusoidal <- function(f,a,p,dt = 2e-4)
{
  t= seq(0,1,by=dt)
  y=a*sin(2*pi*f*t+p)
  return(data.frame(y=y,t=t,f=round(f,digits=2)))
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  sig.data <- reactive(
    {
    freqs <- runif(input$freq_num,min=input$freq_range[1],max =input$freq_range[2])
    amps <- runif(input$freq_num,min=0.1,max =1)
    phase <- runif(input$freq_num,min=0,max =2*pi)
    
    signal <-do.call('rbind',lapply(seq_along(freqs), function(x){getSinusoidal(freqs[x],amps[x],phase[x])}))
    return(signal)
    }
  )
  
  sig.spectrum <- reactive(
    {
      sig.df <- tbl_df(sig.data() )
      full.sig <- sig.df %>% group_by(t) %>% summarise(y = sum(y),f=factor('Full Signal'))
      t = (full.sig$t[2] - full.sig$t[1])*length(full.sig$t)
      df =1/t
      dw = 2*pi*df
      tmp=seq(length(full.sig$t))
      freqs = ifelse(tmp<length(full.sig$t)/2,df*tmp,df*(tmp-length(full.sig$t)))-df
      spectrum = fft(full.sig$y)
      signal.spectrum = data.frame(spectrum = spectrum,freqs=freqs,amp = Mod(spectrum))
      return(signal.spectrum)
    }
  )
  
  output$sigPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    sig.df <- tbl_df(sig.data() )
    #print(sig.df)
    p <- ggplot(data = sig.df,aes(x=t,y=y,col=factor(f))) + geom_line(size=1.5) + theme_minimal() 
    p
  })
  
  output$fullsigPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    sig.df <- tbl_df(sig.data() )
    full.sig <- sig.df %>% group_by(t) %>% summarise(y = sum(y),f=factor('Full Signal'))
    #print(sig.df)
    p <- ggplot(data = full.sig,aes(x=t,y=y)) + geom_line(size=1.5) + theme_minimal() 
    p
  })
  output$spectrumPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    sig.df <- sig.spectrum()
    ff <- unique(sig.data()$f)
    p <- ggplot(data = sig.df,aes(x=freqs,y=amp)) + geom_line(size=1.5)+
      geom_vline(xintercept = ff,col = 'salmon',size=1.5,linetype=2)+
      theme_minimal() +xlim(c(0,40))
    p
  })
  
})
