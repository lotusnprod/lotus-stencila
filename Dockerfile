FROM stencila/executa-midi
USER root

# Install Python dependencies
RUN python3 -m pip install -r requirements.txt

# Install R depedencies
FROM rocker/r-apt:bionic
RUN apt-get update && \
  apt-get install -y libxml2-dev

# Install binaries (see https://datawookie.netlify.com/blog/2019/01/docker-images-for-r-r-base-versus-r-apt/)
COPY ./requirements-bin.txt .
RUN cat requirements-bin.txt | xargs apt-get install -y -qq

# Install remaining packages from source
RUN Rscript -e 'install.packages(c("ggalluvial","ggstar","parallel","readr>=2.0.1"))'
RUN Rscript -e 'BiocManager::install(c("ggtree","ggtreeextra"))'

# Clean up package registry
RUN rm -rf /var/lib/apt/lists/*

# Go back to guest to run the container
USER guest
