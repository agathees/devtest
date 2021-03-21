FROM ||DockerImage||

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm \
    DEBIAN_FRONTEND=noninteractive

ARG PKGS="apt-utils \
    bash-completion \
    bzip2 \
    ca-certificates \
    curl \
    dnsutils \
    file \
    git \
    jq \
    lsb-release \
    locales \
    netcat \
    python3 \
    python3-dev \
    python3-distutils \
    python3-pip \
    python3-setuptools \
    ssh \
    sudo \
    tzdata \
    unzip \
    wget \
    vim \
    zip \
    sssd \
    sssd-tools \
    sssd-ldap \
    ldap-utils \
    libnss-sss \
    libpam-sss"

ARG OVERLAY_VERSION="2.2.0.1"

RUN echo "Fixing staff group GID Number: Started" && \
    groupmod -n staffs dialout && \
    echo "Fixing staff group GID Number: Completed"

RUN apt-get update -y --fix-missing \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends ${PKGS} \
    #openssh-server \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && /usr/sbin/update-locale LANG=$LC_ALL \
    && wget -O /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && apt-get clean  \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* \
    && ln -s /usr/bin/sh /bin/sh \
    && ln -s /usr/bin/bash /bin/bash \
    && ln -s /usr/bin/sed /bin/sed \
    && ln -s /usr/bin/tar /bin/tar

# Download s6-overlay
#ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/
#RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
# Copy the contents of /root directory into /
COPY root/ /

CMD ["/init"]
