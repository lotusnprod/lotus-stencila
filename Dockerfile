FROM stencila/executa-midi

# All installation commands are run as the root user
USER root

# It's good practice to run Docker images as a non-root user.
# This section creates a guest user (if necessary) and sets its home directory as the default working directory.
RUN id -u guest >/dev/null 2>&1 || useradd --create-home --uid 1000 -s /bin/bash guest
WORKDIR /home/guest

# This is a special comment to tell Dockta to manage the build from here on
# dockta

# This section copies package requirement files into the image
COPY requirements.txt requirements.txt
COPY packages.R packages.R
COPY R/check_and_load_packages.R R/check_and_load_packages.R
COPY R/log_debug.R R/log_debug.R

# This section runs commands to install the packages specified in the requirement file/s
RUN pip3 install --requirement requirements.txt \
 &&  bash -c "Rscript packages.R"

# This sets the default user when the container is run
USER guest
