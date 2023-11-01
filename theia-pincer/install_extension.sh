#! /bin/bash
curl https://pincer-server.fly.dev/version/latest/download -o /opt/code-server/pincer.vsix 
code-server --install-extension /opt/code-server/pincer.vsix 
