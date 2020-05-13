# Install lastest version of R
FROM r-base:3.5.3

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev

RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh

# Install R packages that are required
# TODO: add further package if you need!
RUN R -e "install.packages(c('shiny', 'dplyr','rmarkdown','DT','forecast'), dependencies = TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('kableExtra','magick'), dependencies = TRUE, repos='http://cran.rstudio.com/')"
RUN apt-get install -y libxml2-dev
RUN R -e "webshot::install_phantomjs()"

# copy the app to the image
RUN mkdir /root/time_series_app
COPY knitr_report /root/time_series_app

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/time_series_app')"]
