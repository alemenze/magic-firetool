# DESeq
############################################################################

observe({
    updateSelectInput(session, "DESeqFactors", choices=SubmitReactive()$groups, selected='SampleName')
})

DESeqReactive <- eventReactive(input$DESEQ2, {
    withProgress(message='Performing DESeq',
        detail='Please stand by...',
        {
            shiny::setProgress(value = 0.2, detail = "Initializing DESeq Object")
            tryCatch({
                dds <- DESeqDataSetFromMatrix(countData=ProjectData$countdata, colData=ProjectData$metadata, design=as.formula(paste("~", input$DESeqFactors)))
            },
            error=function(e)
            {
                ProjectData$status=paste("DESeq2 Initialize Error: ", e$message)
                showNotification(id="errorNotify", ProjectData$status, type='error', duration=NULL)
            })

            shiny::setProgress(value = 0.4, detail = "Performing DESeq2... Please wait")
            tryCatch({
                dds <- DESeq(dds)
            },
            error=function(e)
            {
                ProjectData$status=paste("DESeq2 Execute Error: ", e$message)
                showNotification(id="errorNotify", ProjectData$status, type='error', duration=NULL)
            })

            shiny::setProgress(value = 0.65, detail = "Performing RLog transformation... this may take a minute")
            rld <- rlog(dds)
            ProjectData$rld=rld
            ProjectData$dds=dds

            ProjectData$status="DESeq2 completed successfully!"
            showNotification(id='DESeq',ProjectData$status,type='message', duration=15)

            ProjectData$ddscounts=as.data.frame(counts(dds, normalized=TRUE))
            return(
                list(
                    "ddscounts"=ProjectData$ddscounts,
                    "rld"=ProjectData$rld,
                    "dds"=ProjectData$dds
                )
            )
        }
    )
})


output$deseq_counts <- renderDataTable({
    DataIn <- DESeqReactive()$ddscounts
    DT::datatable(DataIn, style = "bootstrap", options=list(pageLength = 15,scrollX=TRUE))
})

# Comparisons
############################################################################
observeEvent(input$DESeqFactors, {
    if(input$DESeqFactors != ""){
        updateSelectInput(session, "Comp1", choices=levels(ProjectData$metadata[,input$DESeqFactors]))
        updateSelectInput(session, "Comp2", choices=levels(ProjectData$metadata[,input$DESeqFactors]))
    }
})

CompareReactive <- eventReactive(input$Compare_groups, {
    withProgress(message='Pulling comparisons',
        detail='Please stand by...',
        {
            shiny::setProgress(value = 0.2, detail = "Performing lfc shrinkage and creating differential gene matrix")
            out_res <- results(DESeqReactive()$dds, contrast=c(input$DESeqFactors,input$Comp1, input$Comp2), alpha=0.05)
            shrink <- lfcShrink(DESeqReactive()$dds, contrast=c(input$DESeqFactors,input$Comp1, input$Comp2),res=out_res)
            comp_out <- shrink[order(shrink$padj),]
            comp_out <- merge(as.data.frame(comp_out), as.data.frame(counts(DESeqReactive()$dds, normalized=TRUE)),
            by='row.names', sort=FALSE)
            names(comp_out)[1] <- 'Gene'
            comptemp <- as.data.frame(comp_out)
            compnames <- paste(input$Comp1,'_vs_',input$Comp2, sep='')

            showNotification(id='DEG','Comparison Ready',type='message', duration=15)
            return(
                list(
                    "outcomparison"=comptemp,
                    "outraw"=comp_out,
                    "compnames"=compnames
                )
            )
        }
    )
})

output$comparison_temp <- renderDataTable({
    DataIn <- CompareReactive()$outcomparison
    DT::datatable(DataIn, style = "bootstrap", options=list(pageLength = 15,scrollX=TRUE))
})

# Comparisons to list
############################################################################
SaveCompareReactive <- eventReactive(input$SaveCompare,{
    ProjectData$comparisons <- c(ProjectData$comparisons, list(list(CompareReactive()$compnames,CompareReactive()$outcomparison, CompareReactive()$outraw)))
    outlist <- c()
    for(item in ProjectData$comparisons){
        outlist <- c(outlist, item[1][1])
    }
    listofcomps <- paste0(outlist, collapse=', ')
    return(
        list(
            "comparisons"=ProjectData$comparisons,
            "printlist"=listofcomps,
            "compgroups"=outlist
        )
        
    )
})

output$ListCompares <- renderText({
    SaveCompareReactive()$printlist
})

output$DownloadCompare <- downloadHandler(
    filename=function(){
        paste(CompareReactive()$compnames,'.csv',sep='')
    },
    content = function(file){
        write.csv(CompareReactive()$outcomparison, file)
    }
)