observe({
    GenesList=ProjectData$genestable[['GeneID']]
    updateSelectizeInput(session, "HSelectedGenes", choices=GenesList, server=TRUE, options = list(maxOptions = 50))

})

static_heatmap_plotter <- reactive({
    withProgress(message='Pulling heatmap data',
        detail='Please stand by...',{
    memory.limit(size=25000)

    cluster_r=TRUE
    if (input$HRowClust=='FALSE'){
        cluster_r=FALSE
    }
    cluster_c=TRUE
    if (input$HColClust=='FALSE'){
        cluster_c=FALSE
    }

    shownames=FALSE
    if (input$HShowNames=='TRUE'){
        shownames=TRUE
    }

    my_colors = brewer.pal(n = 11, name = "RdBu")
    my_colors = colorRampPalette(my_colors)(50)
    my_colors = rev(my_colors)
    
    shiny::setProgress(value = 0.55, detail = "Pulling genes")
    if(input$HSubType=='topn'){
        DataIn=DESeqReactive()$dds
        topVarianceGenes <- head(order(rowVars(assay(DataIn)), decreasing=T), input$HTopGenes)
        
        plot <- pheatmap(assay(DataIn)[topVarianceGenes,], cluster_rows=cluster_r, color=my_colors,
            show_rownames=shownames, cluster_cols=cluster_c, scale=input$HScale, fontsize_col=input$HXsize, angle_col=input$Hang)
        
        return(plot)
    }

    if(input$HSubType=='sigdif'){
        DataSetIn=SaveCompareReactive()$comparisons

        sig_genes <- c()

        if (input$HSigP=='padj'){
            for (i in 1:length(DataSetIn)){
                dtmp <- as.data.frame(DataSetIn[[i]][[2]])
                gtmp <- dtmp %>% filter(padj < 0.05)
                glist <- as.list(gtmp['Gene'])
                for (item in glist$Gene){
                    sig_genes <- c(sig_genes, item)
                }
            }
        }
        if (input$HSigP=='pvalue'){
            for (i in 1:length(DataSetIn)){
                dtmp <- as.data.frame(DataSetIn[[i]][[2]])
                gtmp <- dtmp %>% filter(pvalue < 0.05)
                glist <- as.list(gtmp['Gene'])
                for (item in glist$Gene){
                    sig_genes <- c(sig_genes, item)
                }
            }
        }

        sig_genes <- unique(sig_genes)

        DataIn=DESeqReactive()$dds
        DataIn=as.data.frame(counts(DataIn, normalized=TRUE))
        
        DTmpIn <- DataIn[rownames(DataIn) %in% sig_genes,]

        plot <- pheatmap(DTmpIn, cluster_rows=cluster_r, cluster_cols=cluster_c, color=my_colors,
            scale=input$HScale, show_rownames=shownames, fontsize_col=input$HXsize, angle_col=input$Hang)
        
        return(plot)
    }
    if(input$HSubType=='Select'){
        validate(need(length(input$HSelectedGenes)>1, message = "Please choose at least 2 genes."))
        chosen_genes <- c(input$HSelectedGenes)

        DataIn=DESeqReactive()$dds
        DataIn=as.data.frame(counts(DataIn, normalized=TRUE))

        DataSet <- merge(as.data.frame(DataIn), as.data.frame(ProjectData$genestable), by="row.names", sort=FALSE)
        DataSet <- subset(DataSet, select=-c(Gene,Row.names))
        DataSet <- distinct(DataSet, GeneID, .keep_all=TRUE)
        DataSet <- DataSet %>% remove_rownames %>% column_to_rownames(var="GeneID")

        chosen_genes <- unique(chosen_genes)
        DTmpIn <- DataSet[rownames(DataSet) %in% chosen_genes,]
        plot <- pheatmap(DTmpIn, cluster_rows=cluster_r, cluster_cols=cluster_c, color=my_colors,
            scale=input$HScale, show_rownames=shownames, fontsize_col=input$HXsize, angle_col=input$Hang)
        
        return(plot)
    }

    })
})

observe({
    output$heatmap_static <- renderPlot({
        static_heatmap_plotter()
    },height=input$HHeight, width=input$HWidth)
})

output$DownloadHS <- downloadHandler(
    filename=function(){
        paste('heatmap',input$DownHSFormat,sep='.')
    },
    content=function(file){   
        if(input$DownHSFormat=='jpeg'){
            jpeg(file, height=input$CHeight, width=input$CWidth)
            print(static_heatmap_plotter())
            dev.off()
        }
        if(input$DownHSFormat=='png'){
            png(file, height=input$CHeight, width=input$CWidth)
            print(static_heatmap_plotter())
            dev.off()
        }
        if(input$DownHSFormat=='tiff'){
            tiff(file, height=input$CHeight, width=input$CWidth)
            print(static_heatmap_plotter())
            dev.off()
        }
    }
)