# lotus-stencila

-  run `docker build . -t adafede/lotus-stencila` instead
-  push the container image to a Docker container registry (here `docker push adafede/lotus-stencila`)
-  set the container image as execution environment for the project (`adafede/lotus-stencila:latest`)
-  ... almost working (strange ` AttributeError: module 'numpy.random' has no attribute 'BitGenerator'` error
