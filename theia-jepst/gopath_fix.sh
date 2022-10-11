#!/bin/bash

if ! grep '# >>> MARK GOFIX <<<' /home/anubis/.zshrc; then
    echo >> /home/anubis/.zshrc
    echo '# >>> MARK GOFIX <<<' >> /home/anubis/.zshrc
    echo 'export GO_VERSION=1.19' >> /home/anubis/.zshrc
    echo 'export GOOS=linux' >> /home/anubis/.zshrc
    echo 'export GOARCH=amd64' >> /home/anubis/.zshrc
    echo 'export GOROOT=/opt/go<' >> /home/anubis/.zshrc
    echo 'export GOPATH=/opt/go-tools' >> /home/anubis/.zshrc
    echo 'append_path "$GOROOT/bin"' >> /home/anubis/.zshrc
    echo 'append_path "$GOPATH/bin"' >> /home/anubis/.zshrc
fi
