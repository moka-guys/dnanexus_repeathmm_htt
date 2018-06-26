# Use miniconda as parent image
FROM continuumio/miniconda:latest

# Install Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    gcc \
    swig \
    make

# Install conda packages
RUN conda install -y -c bioconda \
    gcc_linux-64 \
    bwa \
    samtools \
    biopython==1.66 \
    hmmlearn \
    scikit-learn \
    trf

# Install pip packages
RUN pip install peakutils==1.0.3

# Set the working directory to /app
WORKDIR /app

# Install RepeatHMM
RUN git clone https://github.com/WGLab/RepeatHMM \
    && cd RepeatHMM/bin/scripts/UnsymmetricPairAlignment \
    && make

# Set the working directory to /app/RepeatHMM/bin
WORKDIR /app/RepeatHMM/bin

# Run repeatHMM.py when the docker container is run
ENTRYPOINT [ "python", "repeatHMM.py" ]

# Default parameter for repeatHMM.py if no paramters supplied by user
CMD [ "-h" ]