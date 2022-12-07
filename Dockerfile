FROM ubuntu:xenial as builder

WORKDIR kafka_exporter

# It requires Ubuntu to build because it inherits the architecture of the computer to have the binary
# The binary needs to belong to a linux/amd platform
# Some requirements are go.19 (apt-get install golang wont work as it downloads go.1.10)
# Then it needs promu for some commands

COPY . .
RUN apt-get update && apt-get install wget make build-essential -y
RUN wget https://go.dev/dl/go1.19.linux-amd64.tar.gz
RUN tar -zxvf go1.19.linux-amd64.tar.gz
RUN mv go /usr/local
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN go version
RUN wget https://github.com/prometheus/promu/releases/download/v0.13.0/promu-0.13.0.linux-amd64.tar.gz
RUN tar -zxvf promu-0.13.0.linux-amd64.tar.gz
RUN mv promu-0.13.0.linux-amd64/promu .

FROM quay.io/prometheus/busybox:latest
COPY --from=builder /kafka_exporter/kafka_exporter /bin/kafka_exporter

EXPOSE     9308
ENTRYPOINT [ "/bin/kafka_exporter" ]
