#!/bin/bash

set -xe

# Install latest pincer extension
curl  https://pincer.anubis-lms.io/version/latest/download -o /opt/code-server/pincer.vsix 
/usr/bin/code-server --user-data-dir=/opt/code-server --install-extension /opt/code-server/pincer.vsix 

# Download study base files if not already there
if [ ! -d /home/anubis/2023_study ]; then
    git clone https://github.com/GusSand/2023_study.git
fi
