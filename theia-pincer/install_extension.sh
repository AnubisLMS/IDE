#! /bin/bash
curl https://pincer-server.fly.dev/version/latest/download -o /opt/pincer.vsix 
code-server --install-extension /opt/pincer.vsix 
