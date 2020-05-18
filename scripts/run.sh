#!/bin/bash

# Initialize first run
if [[ -e /.firstrun ]]; then
    /scripts/init.sh
fi

# Start CouchDB
echo "Starting CouchDB..."
/usr/local/bin/couchdb
