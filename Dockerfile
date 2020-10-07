# This dockerfile is a portable, pre-built version of Volatility 3
# with the Windows PDB's already installed
#
# It has been built using the python:3.8.5-slim-buster docker to ensure it 
# remains relatively small in size, while supporting both the apt requirements
# and the python3 requirements.
#
# It can be run by using the 'vol' command after entering the following:
#
# sudo docker run --rm -it digitalsleuth/vol3-docker /bin/bash

FROM python:3.8.5-slim-buster
LABEL description="Volatility 3 w/Windows pdb's"
LABEL version="1.0"
LABEL maintainer="Corey Forman (github.com/digitalsleuth)"

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get upgrade -y && apt-get install git nano wget gcc unzip -y

RUN pip3 install pefile jsonschema yara-python pycryptodome capstone && \
    pip3 install git+https://github.com/volatilityfoundation/volatility3.git@master && \
    ln -s /usr/local/lib/python3.8/site-packages/usr/local/lib/libyara.so /usr/local/lib/libyara.so

RUN wget https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip && \
    unzip -d /usr/local/lib/python3.8/site-packages/volatility/symbols/ windows.zip && \
    rm windows.zip
