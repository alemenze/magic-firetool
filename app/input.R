ProjectData<- reactiveValues(datafile=NULL, metadatafile=NULL, design=NULL, species=NULL,dds=NULL)

output$specieschoice <- renderUI({
    if (is.null(input$datafile) || is.null(input$metadatafile)) return()
    tagList(
        radioButtons("species",label='Select species',choices=c('Human','Mouse','Other'), inline=F, selected='Human'),
        actionButton('submit',"Submit Data",class='btn btn-success',)
    )
})

observeEvent(input$submit, {
    ProjectData$datafile=input$datafile$datapath
    ProjectData$metadatafile=input$metadatafile$datapath
    ProjectData$species=input$species
})

SubmitReactive <- reactive({

    shiny::validate(
        need((!is.null(ProjectData$datafile)),
        message='')
    )

    withProgress(message='Preparing data',
        detail='Please stand by...',
        {
            shiny::setProgress(value = 0.15, detail = "Loading Hit Counts")
            filecontents=read.csv(ProjectData$datafile, header=T, sep=input$separator, row.names=1)
           
            counts <- filecontents[, -c(1)]
            counts <- counts[,order(names(counts))]

            genetable <- subset(filecontents, select=c(1))
            names(genetable)[1] <- 'GeneID'
            genetable$Gene <- rownames(genetable)

            ProjectData$rawdatacounts=filecontents
            ProjectData$genestable=genetable

            shiny::setProgress(value = 0.35, detail = "Loading Metadata")
            filecontents = read.csv(ProjectData$metadatafile, header=T, sep=input$metaseparator, row.names=1)

            sampletable <- filecontents[order(row.names(filecontents)),]
            countdata <- as.matrix(counts)[, colnames(counts) %in% rownames(sampletable)]

            ProjectData$countdata=countdata
            ProjectData$metadata=sampletable
            groupvars=colnames(sampletable)
            ProjectData$groups=groupvars

            return(
                list(
                    "rawdatacounts"=ProjectData$rawdatacounts,
                    "metadata"=ProjectData$metadata,
                    "groups"=ProjectData$groups,
                    "countdata"=ProjectData$countdata,
                    "genestable"=ProjectData$genestable
                )
            )
        }
    )     
})


output$counts_contents <- DT::renderDataTable({
    DataIn <- SubmitReactive()$rawdatacounts
    DT::datatable(DataIn, style = "bootstrap", options=list(pageLength = 15,scrollX=TRUE))
})

output$meta_contents <- renderDataTable({
    DataIn <- SubmitReactive()$metadata
    DT::datatable(DataIn, style = "bootstrap", options=list(pageLength = 15,scrollX=TRUE))
})