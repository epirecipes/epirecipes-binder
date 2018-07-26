FROM jupyter/datascience-notebook:8d22c86ed4d7

# Set user
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

## Change user to root to install
USER root

## Add Conda stuff
RUN conda install -f environment.yml

## run any install.R script we find
RUN R --quiet -f install.R

## Set default 'type' for png() calls - useful when X11 device is not available!
## NOTE: Needs 'cairo' capability
COPY ./irkernel.json /opt/conda/share/jupyter/kernels/ir/kernel.json

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
