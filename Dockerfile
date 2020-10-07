# This dockerfile is a portable, pre-built version of Volatility 3
# with the Windows PDB's already installed
#
# The original source software can be found here:
# https://github.com/volatilityfoundation/volatility3
#
# It has been built using the python:3.8.5-slim-buster docker to ensure it 
# remains relatively small in size, while supporting both the apt requirements
# and the python3 requirements.
#
# It can be run by using the 'vol' command after entering the following:
#
# sudo docker run --rm -it -v <local_directory>:/home/nonroot/files digitalsleuth/vol3-docker
#
# where <local_directory> is a location containing your memory dumps on your local host

FROM python:3.8.5-slim-buster
LABEL description="Volatility 3 w/Windows pdb's"
LABEL version="1.0"
LABEL maintainer="Corey Forman (github.com/digitalsleuth)"
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

USER root
RUN apt-get update && apt-get upgrade -y && apt-get install git nano wget gcc unzip -y

RUN pip3 install pefile jsonschema yara-python pycryptodome capstone && \
    pip3 install git+https://github.com/volatilityfoundation/volatility3.git@master && \
    ln -s /usr/local/lib/python3.8/site-packages/usr/local/lib/libyara.so /usr/local/lib/libyara.so

RUN wget https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip && \
    unzip -d /usr/local/lib/python3.8/site-packages/volatility/symbols/ windows.zip && \
    rm windows.zip

RUN apt-get autoremove -y --purge && apt-get clean -y

RUN groupadd -r nonroot && \
    useradd -m -r -g nonroot -d /home/nonroot -s /usr/sbin/nologin -c "Nonroot User" nonroot && \
    mkdir -p /home/nonroot/files && \
    chown -R nonroot:nonroot /home/nonroot && \
    usermod -a -G sudo nonroot && echo 'nonroot:nonroot' | chpasswd

USER nonroot
ENV HOME /home/nonroot
WORKDIR /home/nonroot/files
VOLUME ["/home/nonroot/files"]
ENV USER nonroot
CMD ["/bin/bash"]

