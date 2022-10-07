FROM stencila/executa-midi:latest

USER root

RUN Rscript -e 'install.packages(c("BiocManager","data.table","dplyr","forcats","ggalluvial","ggfittext","ggplot2","ggnewscale","parallel","pbmcapply","philentropy","plotly","readr","rotl","splitstackshape","tidyr","UpSetR"))'
RUN Rscript -e 'BiocManager::install(c("ggtree","ggtreeExtra","ggstar"))'

USER guest
