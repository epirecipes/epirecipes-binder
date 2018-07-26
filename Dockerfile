FROM jupyter/datascience-notebook:8d22c86ed4d7

# Set user
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

## Change user to root to install
USER root

## Add Conda stuff
RUN if [ -f environment.yml ]; then conda env update -f environment.yml; fi

RUN conda install --force r-cairo=1.5.9=mro343h889e2dd_0

## run any install.R script we find
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

## Set default 'type' for png() calls - useful when X11 device is not available!
## NOTE: Needs 'cairo' capability
COPY ./irkernel.json /opt/conda/share/jupyter/kernels/ir/kernel.json

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
