# Biodiverse

[![GitHub license](https://img.shields.io/github/license/vmikk/biodiverse-docker)](https://github.com/vmikk/biodiverse-docker/blob/main/LICENSE)
[![Hosted_DockerHub](https://img.shields.io/badge/Hosted-DockerHub-blue)](https://hub.docker.com/r/vmikk/biodiverse)
[![Hosted_SingularityLibrary](https://img.shields.io/badge/Hosted-SingularityLibrary-blue)](https://cloud.sylabs.io/library/vmiks/gbif/biodiverse)


This repository contains definition files the [Biodiverse](https://shawnlaffan.github.io/biodiverse/) (Laffan et al., 2010) containers.


# Docker image

To build the [Docker](https://www.docker.com/) image with Biodiverse run:
```
docker build --tag biodiverse --file Dockerfile_NoPerlbrew . 
```
The `Dockerfile_NoPerlbrew` should be present in the current directory.


A ready-to-use image is available at [Docker Hub](https://hub.docker.com/r/vmikk/biodiverse) and can be downloaded with:
```
docker pull vmikk/biodiverse:1.3.0
```


# Singularity image

To build the [Singularity](https://sylabs.io/singularity/) image with Biodiverse run:
```
sudo singularity build Biodiverse.sif SingularityDef_NoPerlbrew.def
```
The `SingularityDef_NoPerlbrew.def` should be present in the current directory.


A ready-to-use image is available at the [Singularity Library](https://cloud.sylabs.io/library/vmiks/gbif/biodiverse) and can be downloaded with:
```
singularity pull --arch amd64 library://vmiks/gbif/biodiverse:1-3-0
```


# Citation

Laffan SW, Lubarsky E, Rosauer DF (2010) Biodiverse, a tool for the spatial analysis of biological and related diversity. Ecography, 33: 643-647. [DOI: 10.1111/j.1600-0587.2010.06237.x](https://onlinelibrary.wiley.com/doi/10.1111/j.1600-0587.2010.06237.x)
