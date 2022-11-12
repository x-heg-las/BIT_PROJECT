FROM ubuntu:20.04
RUN apt update -y && apt install -y python python-dev build-essential curl && curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output /tmp/get-pip.py && python2 /tmp/get-pip.py

RUN mkdir /app
COPY src /app
WORKDIR /app

RUN pip2 install -r requirements.txt

ENTRYPOINT ["python2"]
CMD ["app.py"]
