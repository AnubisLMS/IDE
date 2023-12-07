#! /bin/bash
curl  https://pincer-server.fly.dev/version/latest/download -o /opt/code-server/pincer.vsix 
/usr/bin/code-server --user-data-dir=/opt/code-server --install-extension /opt/code-server/pincer.vsix 

if [ ! -d /home/anubis/2023_study ]; then
    git clone https://github.com/GusSand/2023_study.git
fi

exit 0
