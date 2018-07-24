install.packages(install.packages(c(
'Cairo',
'reshape2',
'deSolve',
'simecol',
'Rcpp',
'ggplot2',
'plotly',
'pomp',
'GillespieSSA'
), repos='https://mran.microsoft.com/snapshot/2018-07-01', method='libcurl')
devtools::install_github("mrc-ide/odin", ref="dd8c34a", upgrade = FALSE)
