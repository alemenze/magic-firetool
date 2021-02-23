# Input data
########################################################################################################
observeEvent(input$hitcount_example, {
    showModal(modalDialog(
        column(12,tags$img(src='feature_count_img.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$metadata_example, {
    showModal(modalDialog(
        column(12,tags$img(src='meta_img.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

# Clustering
########################################################################################################
observeEvent(input$pca_example, {
    showModal(modalDialog(
        column(12,tags$img(src='pca.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$dm_example, {
    showModal(modalDialog(
        column(12,tags$img(src='dm.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$eigen_example, {
    showModal(modalDialog(
        column(12,tags$img(src='eigencor.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

# Comparisons
########################################################################################################
observeEvent(input$volcano_example, {
    showModal(modalDialog(
        column(12,tags$img(src='volcano.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$venn_example, {
    showModal(modalDialog(
        column(12,tags$img(src='venn.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$upset_example, {
    showModal(modalDialog(
        column(12,tags$img(src='upset.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

# Genes
########################################################################################################
observeEvent(input$heatmap_example, {
    showModal(modalDialog(
        column(12,tags$img(src='heatmap.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$box_example, {
    showModal(modalDialog(
        column(12,tags$img(src='boxplot.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$violin_example, {
    showModal(modalDialog(
        column(12,tags$img(src='violinplot.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

# Pathways
########################################################################################################
observeEvent(input$dotplot_example, {
    showModal(modalDialog(
        column(12,tags$img(src='gsea_dotplot.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$enrich_example, {
    showModal(modalDialog(
        column(12,tags$img(src='gsea_emap.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$gsea_example, {
    showModal(modalDialog(
        column(12,tags$img(src='gseaplot.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})

observeEvent(input$pathviewer_example, {
    showModal(modalDialog(
        column(12,tags$img(src='pathview.png'), align='center', hr()),
        easyClose = TRUE,
        size='l'
    ))    
})
