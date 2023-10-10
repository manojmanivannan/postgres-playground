# Use an official Python runtime as a parent image
FROM python:3.8

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY dataset/job.py /app/job.py

# Install any needed packages specified in requirements.txt
RUN pip install psycopg2-binary faker

# Run the Python script
CMD ["python", "job.py"]
