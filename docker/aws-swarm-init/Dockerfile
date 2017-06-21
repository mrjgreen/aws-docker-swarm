FROM python:2.7-alpine

RUN pip install docker boto3

WORKDIR /

COPY entry.py /

CMD ["python", "entry.py"]
