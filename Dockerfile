FROM jupyter/datascience-notebook:8d22c86ed4d7

# Set user
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

## Change user to root to install
USER root

## Add Conda stuff
RUN conda install --quiet --yes \
    xeus-cling=0.4.5 \
    xtensor=0.16.4 \
    xtensor-blas=0.11.1 \
    -c QuantStack && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

## run any install.R script we find
RUN R ---slave -e  "install.packages(c(
'devtools',
'Cairo',
'reshape2',
'deSolve',
'simecol',
'Rcpp',
'ggplot2',
'plotly',
'pomp',
'GillespieSSA'
), repos='https://mran.microsoft.com/snapshot/2018-07-01', method='libcurl');
devtools::install_github("mrc-ide/odin", ref="dd8c34a", upgrade = FALSE)"

## NOTE: Needs 'cairo' capability
COPY ./irkernel.json /opt/conda/share/jupyter/kernels/ir/kernel.json

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
