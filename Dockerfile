# Pull base image
FROM python:3.7
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
# Set work directory
WORKDIR /code
# Install dependencies
RUN pip install pipenv
COPY Pipfile Pipfile.lock /code/
RUN pipenv install --system
# Copy project
COPY . /code/
#CMD ["/app/manage.py", "runserver"]
CMD ["python", "/code/manage.py", "runserver", "0.0.0.0:8000"]
