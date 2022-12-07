FROM ubuntu:xenial as builder

WORKDIR kafka_exporter

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
