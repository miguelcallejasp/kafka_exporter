#!/bin/zsh

docker build -t gcr.io/mojix-registry/kafka-exporter:main .
docker push gcr.io/mojix-registry/kafka-exporter:main