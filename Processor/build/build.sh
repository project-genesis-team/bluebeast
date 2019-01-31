# build.sh is only required to the vagrant machine first runs
# This builds all required Dockerfiles, caches images and runs standalone daemons (ipfs)

sudo docker build -t ipfsnode $HOME/build
sudo docker run -d -p 4001:4001 -p 127.0.0.1:8080:8080 -p 127.0.0.1:5001:5001 -it ipfsnode