
FROM eddelbuettel/r2u:20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# install R packages, the packages behhind the 'learnr' should be modified based on your r script
RUN install.r shiny rmarkdown learnr readr deSolve EpiEstim tidyverse lubridate

RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app
COPY . .
# change the file name based on the actual name of your r script
RUN R -e "rmarkdown::render('CAMUS_Course.Rmd')"
ENV RMARKDOWN_RUN_PRERENDER=0
RUN chown app:app -R /home/app
USER app

EXPOSE 3838
# change the file field based on the actual name of your r script
CMD ["R", "-e", "rmarkdown::run(file = 'CAMUS_Course.Rmd', shiny_args = list(port = 3838, host = '0.0.0.0'))"]