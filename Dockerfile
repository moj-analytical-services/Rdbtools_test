ARG DE_ECR
FROM ${DE_ECR}/r-airflow:4.1.2-2

# Create a working directory
WORKDIR /etl

# Add R package requirements and scripts
#COPY renv.lock renv.lock
COPY scripts/ scripts/

# Give working directory permissions to everyone
RUN chmod -R 777 .

# Use the latest repos for R
RUN R -e "options(repos = c(PPM = 'https://packagemanager.posit.co/cran/latest'))"
# Install renv globally
RUN R -e "install.packages('renv')"

# Create a user with a home directory, which is necessary for renv
# The user id must be the same as defined in the Airflow DAG
RUN adduser --uid 1337 daguser
USER daguser

# Inititalise renv...
RUN R -e "renv::init()"
# ... and restore the R environment
RUN R -e "renv::install('paws', type = 'binary')"
RUN R -e "renv::install('moj-analytical-services/Rdbtools')"
RUN R -e "renv::snapshot()"

# Run the DAG task
ENTRYPOINT Rscript scripts/run.R
