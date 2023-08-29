ARG DE_ECR
FROM ${DE_ECR}/r-airflow:4.1.2-2

# Create a working directory
WORKDIR /etl

# Add Python package requirements
COPY requirements.txt requirements.txt

# Add R package requirements and scripts
COPY renv.lock renv.lock
COPY scripts/ scripts/

# Give working directory permissions to everyone
RUN chmod -R 777 .

# Use the latest repos for R
RUN R -e "options(repos = 'https://cran.rstudio.com')"
# Install renv globally
RUN R -e "install.packages('renv')"

# Create a user with a home directory, which is necessary for renv
# Make sure the userid is the same as specified in the Kubernetes pod operator `run_as_user`
# in your Airflow DAG file
RUN adduser --uid 1337 daguser
USER daguser

# Inititalise renv...
RUN R -e "renv::init()"
# tell it to use Python...
RUN R -e "renv::use_python()"
# ... and restore the R and Python environments
RUN R -e 'renv::restore()'

# Run the DAG task
ENTRYPOINT Rscript scripts/run.R
