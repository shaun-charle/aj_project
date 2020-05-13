# Install lastest version of R from open analytics
FROM openanalytics/r-base

# system libraries of general use

RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# system library dependency for the app
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh

RUN apt-get install -y html-xml-utils 
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libv8-dev
RUN apt-get install -y libmagick++-dev

# install packages for R
RUN R -e "install.packages('magick', dependencies = TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('hms','devtools'), repos='https://cloud.r-project.org/')"
RUN R -e "require(devtools)"
RUN R -e "devtools::install_version('readxl', version = '1.0.0', dependencies= T, repos='https://cloud.r-project.org/')"
RUN R -e "devtools::install_version('DT', version = '0.2', dependencies= T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('knitr', dependencies=TRUE, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('dplyr', dependencies=TRUE, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('shiny', dependencies=TRUE, repos='https://cloud.r-project.org/')"
RUN R -e "devtools::install_version('rmarkdown', version = '1.8', dependencies=T, repos='https://cloud.r-project.org/')"
RUN R -e "devtools::install_version('kableExtra', version = '1.0.1', dependencies=T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('forecast', dependencies = TRUE, repos='http://cran.rstudio.com/')"


RUN R -e "webshot::install_phantomjs()"

# copy the app to the image
RUN mkdir /root/time_series_app
COPY time_series_app /root/time_series_app

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/time_series_app')"]
