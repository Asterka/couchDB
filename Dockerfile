FROM asterka/ubuntu

# Install and configure CouchDB 1.6.1
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --force-yes \
    erlang-dev \
    erlang-manpages \
    erlang-base-hipe \
    erlang-eunit \
    erlang-nox \
    erlang-xmerl \
    erlang-inets \
    libmozjs185-dev \
    libicu-dev \
    libcurl4-gnutls-dev \
    libtool && \
    cd /tmp && \
    wget https://archive.apache.org/dist/couchdb/source/1.6.1/ && \
    tar xzvf apache-couchdb-1.6.1.tar.gz && \
    cd apache-couchdb-1.6.1 && \
    ./configure && \
    make && \
    make install && \
    sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i /usr/local/etc/couchdb/default.ini && \
    sed -e 's/^database_dir = .*$/database_dir = \/data/' -i /usr/local/etc/couchdb/default.ini && \
    sed -e 's/^view_index_dir = .*$/view_index_dir = \/data/' -i /usr/local/etc/couchdb/default.ini && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose listen port
EXPOSE 5984

# Expose our data, logs and configuration volumes
VOLUME ["/data", "/usr/local/var/log/couchdb", "/usr/local/etc/couchdb"]
