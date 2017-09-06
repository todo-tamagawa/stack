# Build environment for M-IX
FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
MAINTAINER nishida "nishida@xcompass.com"

# Install dependencies.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 575159689BEFB442
RUN echo 'deb http://download.fpcomplete.com/ubuntu yakkety main'| tee /etc/apt/sources.list.d/fpco.list
RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN echo "deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y byobu curl git htop man unzip vim wget
RUN apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        libboost-thread-dev \
        stack \
        cmake-curses-gui \
        postgresql-server-dev-all \
        postgresql-client-9.3 \
        postgresql-contrib \
        libpq-dev \
        libfftw3-dev \
        libfaac-dev \
        qt5-default qttools5-dev-tools \
        libgstreamer0.10-0 \
        libgstreamer-plugins-base0.10-0 \
        libopenblas-dev \
        libgtk-3-dev \
        liblapack-dev \
        liblapacke-dev \
        checkinstall \
        unzip \
        fakeroot

# prepare db
USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "ALTER ROLE postgres WITH PASSWORD 'postgres';" && \
    psql --command "CREATE USER ix WITH SUPERUSER PASSWORD 'ix';" && \
    createdb -O postgres ix

# nodejs
USER root

RUN apt-get install -y nodejs npm
RUN npm cache clean
RUN npm install n -g
RUN n stable
RUN ln -sf /usr/local/bin/node /usr/bin/node
RUN apt-get purge -y nodejs npm
# `--unsafe-perm` is workaround 
# -> https://stackoverflow.com/questions/44878798/permission-denied-error-while-attempting-to-install-elm-with-sudo-on-ubuntu
RUN npm install --unsafe-perm -g elm

# IX
ENV DEV_ROOT=/root/dev
RUN mkdir -p $DEV_ROOT
WORKDIR $DEV_ROOT

CMD ["/bin/bash"]

