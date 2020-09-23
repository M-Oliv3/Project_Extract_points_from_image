
library(shiny)
library(jpeg)
library(RCurl)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        values <- reactiveValues(Data = NULL)
        
        v <- reactiveValues(startpoint =c(0,0),
                            Axis.x=0,
                            Axis.y=0,
                            pts.1=c(0,0),
                            px=0)
        
        observeEvent(input$plot_click, {
                if (input$state=="Origin") {
                        v$startpoint <- c(input$plot_click$x,input$plot_click$y)
                } else if (input$state=="X - Axis"){
                        v$Axis.x <- input$plot_click$x
                        
                } else{
                        if (input$state=="Y - Axis"){
                                v$Axis.y <- input$plot_click$y
                        } else {
                                v$pts.1 <- c(input$plot_click$x,input$plot_click$y)
                                
                        }
                        
                }
                
        })
        
        
        px<- reactive({
                x0<-as.numeric(input$AxisX)
                Ax<-data.frame(x=c(v$startpoint[1],v$Axis.x),y=c(0,x0))
                model<-lm(y~x,Ax)
                (v$pts.1[1])*model$coef[2]+model$coef[1]
                
        })
        
        py<- reactive({
                y0<-as.numeric(input$AxisY)
                Ay<-data.frame(x=c(v$startpoint[2],v$Axis.y),y=c(0,y0))
                model1<-lm(y~x,Ay)
                (v$pts.1[2])*model1$coef[2]+model1$coef[1]
                
        })
        
        observeEvent(input$plot_click, {
                if (input$state=="Points") {
                        values$Data <- rbind(values$Data, c(px(),py()))
                }
        })
        
        observeEvent(input$clean, {
                values$Data <- NULL
        })
        
        
        output$result2<- renderText({
                if(is.null(input$plot_click)) return("NULL\n")
                if (input$state=="Origin"){
                        paste("X: ", v$startpoint[1],"Y: ", v$startpoint[2])
                } else if (input$state=="X - Axis"){
                        paste("Value: ", v$Axis.x)
                        
                } else{
                        if (input$state=="Y - Axis"){
                                paste("Value: ", v$Axis.y)
                        }
                        
                }
                
        })
        
        
        output$distPlot <- renderPlot({
                
                file <- input$file1
                ext <- tools::file_ext(file$datapath)
                
                req(file)
                validate(need(ext == "jpg", "Please upload a jpg file"))
                
                image<-readJPEG(file$datapath)
                
                plot(1:2, type='n', main="Image", xlab="x", ylab="y",xaxt="n",yaxt="n")
                
                #Get the plot information so the image will fill the plot box, and draw it
                lim <- par()
                rasterImage(image, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])
                
        })
        
        
        output$info <- renderText({
                paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
        })
        output$Pts <-  renderText({
                paste0("x=", px(), "\ny=", py())
        })
        
        output$data <- renderTable({
                values$Data
        })
        
})
