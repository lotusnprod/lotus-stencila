FROM stencila/executa-midi
USER root

# Download miniconda https://stackoverflow.com/questions/58269375/how-to-install-packages-with-miniconda-in-dockerfile
ENV PATH=/root/miniconda3/bin:$PATH
ARG PATH=/root/miniconda3/bin:$PATH
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

# Add the conda lotus_stencila_env to the container
ENV CONDA_ENV lotus_stencila_env
COPY lotus_stencila_env.yml /tmp/$CONDA_ENV.yml
RUN conda env create -q -f /tmp/lotus_stencila_env.yml -n $CONDA_ENV
SHELL ["/bin/bash", "-c"]
RUN conda init
RUN echo 'conda activate lotus_stencila_env' >> ~/.bashrc

# Go back to guest to run the container
USER guest
