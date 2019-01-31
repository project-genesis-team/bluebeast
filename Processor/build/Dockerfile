FROM amd64/ubuntu:latest
RUN apt-get update

COPY . /ipfs
WORKDIR /ipfs/go-ipfs
ENV PATH /ipfs/go-ipfs:$PATH

RUN ipfs init

RUN ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
RUN ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001

EXPOSE 8080
EXPOSE 8081
EXPOSE 5001
EXPOSE 4001 
EXPOSE 4002/udp

CMD ["ipfs", "daemon"]