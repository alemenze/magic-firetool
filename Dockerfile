FROM rocker/shiny:3.6.1
LABEL authors="Alex Lemenze" \
    description="Docker image containing the MaGIC FIRE Tool."

RUN apt-get update && apt-get install -y \ 
    sudo libssl-dev libv8-dev libsodium-dev libxml2-dev \
    libcurl4-openssl-dev libjpeg62-turbo-dev

RUN R -e "install.packages(c('shiny','DT','VennDiagram','jpeg','readr','ggthemes','markdown','tidyr','rmarkdown','Hmisc','tidyverse','r-lib','shinythemes','shinycssloaders','RColorBrewer','pheatmap','ggplot2','shinyjs','dplyr','colourpicker','UpSetR'),repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('GenomicRanges','SummarizedExperiment','Biobase','genefilter','locfit','geneplotter','Hmisc','RcppArmadillo','msigdbr','stringr'),repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('remotes'),repos='http://cran.rstudio.com/')"
RUN R -e 'install.packages("XML", repos = "http://www.omegahat.net/R")'
RUN R -e "install.packages('BiocManager')"
RUN R -e "BiocManager::install(c('EnhancedVolcano','annotate','geneplotter','genefilter','clusterProfiler','pathview','enrichplot'))"
RUN R -e "remotes::install_github('kevinblighe/PCAtools')"
RUN R -e "BiocManager::install(c('DESeq2'))"
RUN R -e "BiocManager::install('org.Mm.eg.db', character.only = TRUE)"
RUN R -e "BiocManager::install('org.Hs.eg.db', character.only = TRUE)"
RUN R -e "install.packages(c('httpuv'),repos='http://cran.rstudio.com/')"

COPY ./app /srv/shiny-server/
COPY shiny-customized.config /etc/shiny-server/shiny-server.conf
RUN sudo chown -R shiny:shiny /srv/shiny-server
EXPOSE 8080

USER shiny
CMD ["/usr/bin/shiny-server"]