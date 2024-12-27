# Use the official Apache Superset image as a base
FROM apache/superset:latest

# Install necessary packages
RUN pip install gevent psycopg2-binary

# Set the environment variables for Superset
ENV SUPERSET_HOME=/app/superset
ENV SUPERSET_SECRET_KEY=your_super_secret_key
ENV SQLALCHEMY_DATABASE_URI=postgresql+psycopg2://superset:superset@db:5432/superset
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379

# Initialize and load example data
RUN /bin/bash -c \
    "superset fab create-admin --username admin --firstname Superset --lastname Admin --email admin@superset.com --password admin && \
    superset db upgrade && \
    superset load_examples && \
    superset init"

# Expose the necessary port
EXPOSE 8088

# Run Superset with Gunicorn
ENTRYPOINT ["gunicorn", "-w", "3", "-k", "gevent", "--timeout", "120", "-b", "0.0.0.0:8088", "superset.app:create_app()"]

