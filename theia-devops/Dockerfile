FROM registry.digitalocean.com/anubis/theia-base:python-3.13 as theia
USER root

COPY requirements.txt requirements-dev.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt -r /requirements-dev.txt

USER anubis
