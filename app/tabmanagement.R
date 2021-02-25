# Hiding and showing tabs on command!
############################################################################
observe({
    if(is.null(input$datafile)){
        hideTab(inputId = "NAVTABS", target = "Enrichment Pathways")
        hideTab(inputId = "NAVTABS", target = "Venn Diagrams")
        hideTab(inputId = "NAVTABS", target = "Gene Expression Plots")
        hideTab(inputId = "NAVTABS", target = "Heatmap Plots")
        hideTab(inputId = "NAVTABS", target = "Volcano Plots")
        hideTab(inputId = "NAVTABS", target = "Clustering Plots")
        hideTab(inputId = "NAVTABS", target = "DESeq2")
    }
})

observeEvent(input$submit,{
    showTab(inputId = "NAVTABS", target = "DESeq2")
})

observeEvent(input$DESEQ2,{
    showTab(inputId = "NAVTABS", target = "Clustering Plots")
    showTab(inputId = "NAVTABS", target = "Gene Expression Plots")
    showTab(inputId = "NAVTABS", target = "Heatmap Plots")
})

observeEvent(input$SaveCompare,{
    showTab(inputId = "NAVTABS", target = "Volcano Plots")
    showTab(inputId = "NAVTABS", target = "Venn Diagrams")
    if(input$species != 'Other'){
        showTab(inputId = "NAVTABS", target = "Enrichment Pathways")
    }
})

# Download button rendering
##################################################################################
output$DESeqDownload <- renderUI({
    if (is.null(DESeqReactive()$ddscounts)) return()
    tagList(
        column(12, align='center',downloadButton('DownloadDESeqNorm', 'Download the Normalized Counts')),
        column(12, align='center',tags$p('Do note- these will also be downloaded with downstream comparisons you download.', style="margin-bottom:50px;"))
    )
})

output$ComparisonDownload <- renderUI({
    if (is.null(CompareReactive()$outcomparison)) return()
    tagList(
        column(12, align='center',downloadButton('DownloadCompare', 'Download the Comparison'), style="margin-bottom:50px;")
    )
})

output$PCADownload <- renderUI({
    if (is.null(pcaplotter())) return()
    tagList(
        column(12, selectInput("DownPCAFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadPCA', 'Download the PCA Plot'),style="margin-bottom:50px;")
    )
})

output$DMDownload <- renderUI({
    if (is.null(distanceplotter())) return()
    tagList(
        column(12, selectInput("DownDMFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadDM', 'Download Distance Matrix'),style="margin-bottom:50px;")
    )
})

output$EigenDownload <- renderUI({
    if (is.null(eigencorplotter())) return()
    tagList(
        column(12, selectInput("DownEigenFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadEigen', 'Download Eigen Correlation Plot'),style="margin-bottom:50px;")                   
    )
})

output$VolcanoDownload <- renderUI({
    if (is.null(static_volcano_plotter())) return()
    tagList(
        column(12, selectInput("DownVSFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadVS', 'Download Volcano Plot'),style="margin-bottom:50px;")
    )
})

output$HeatmapDownload <- renderUI({
    if (is.null(static_heatmap_plotter())) return()
    tagList(
        column(12, selectInput("DownHSFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadHS', 'Download Heatmap'),style="margin-bottom:50px;")
    )
})

output$BoxPlotDownload <- renderUI({
    if (is.null(box_plotter())) return()
    tagList(
        column(12, selectInput("DownBoxFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadBox', 'Download Box Plot'),style="margin-bottom:50px;")
    )
})

output$ViolinPlotDownload <- renderUI({
    if (is.null(violin_plotter())) return()
    tagList(
        column(12, selectInput("DownViolinFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadViolin', 'Download Violin Plot'),style="margin-bottom:50px;")
    )
})

output$VennDownload <- renderUI({
    if (is.null(static_venn_plotter())) return()
    tagList(
        column(12, selectInput("DownVennSFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadVennS', 'Download Venn Diagram'),style="margin-bottom:50px;")
    )
})

output$UpSetDownload <- renderUI({
    if (is.null(upset_plotter())) return()
    tagList(
        column(12, selectInput("DownUpsetFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadUpset', 'Download UpSet Plot'),style="margin-bottom:50px;")
    )
})

output$GSEAPlotDownload <- renderUI({
    if (is.null(GSEAReactive())) return()
    tagList(
        column(12, selectInput("DownGSEAFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadGSEAPlot', 'Download GSEA Plot'),style="margin-bottom:50px;")
    )
})

output$GSEATableDownload <- renderUI({
    if (is.null(GSEAReactive())) return()
    tagList(
        column(12, downloadButton('DownloadGSEATable', 'Download GSEA Table'),style="margin-bottom:50px;")
    )
})

output$ORAPlotDownload <- renderUI({
    if (is.null(ORAReactive())) return()
    tagList(
        column(12, selectInput("DownORAFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadORAPlot', 'Download ORA Plot'),style="margin-bottom:50px;")
    )
})

output$ORATableDownload <- renderUI({
    if (is.null(ORAReactive())) return()
    tagList(
        column(12, downloadButton('DownloadORATable', 'Download ORA Table'),style="margin-bottom:50px;")
    )
})

output$GSEASoloDownload <- renderUI({
    if (is.null(GSEAReactive())) return()
    tagList(
        column(12, selectInput("DownGSEASoloFormat", label='Choose download format', choices=c('jpeg','png','tiff'))),
        column(12, downloadButton('DownloadGSEASoloPlot', 'Download GSEA Plot'),style="margin-bottom:50px;")
    )
})

output$GSEAKEGGDownload <- renderUI({
    if (is.null(KEGGReactiveGSEA())) return()
    tagList(
        column(12, downloadButton('DownloadGSEAKEGGPlot', 'Download GSEA KEGG Plot'),style="margin-bottom:50px;")
    )
})

output$ORAKEGGDownload <- renderUI({
    if (is.null(KEGGReactiveORA())) return()
    tagList(
        column(12, downloadButton('DownloadGSEAORAPlot', 'Download ORA KEGG Plot'),style="margin-bottom:50px;")
    )
}) 