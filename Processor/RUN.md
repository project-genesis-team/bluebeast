## Prerequisites

Install `virtualbox` and `vagrant`.

* VirtualBox ([install](https://www.virtualbox.org/wiki/Downloads))
* Vagrant ([install](https://www.vagrantup.com/downloads.html))

Cache required vagrant box `williamyeh/ubuntu-trusty64-docker`.

```sh
vagrant box add "williamyeh/ubuntu-trusty64-docker"
``` 

## Running

\**Note: As the repository is currently private I have setup an access token to clone. This would not work otherwise.*

1. Clone bluebeast
2. Change directory to bluebeast

```sh
git clone https://harryrford:f532baf8f88210b2d2cbf659a16ab15121ae54b5@github.com/project-genesis-team/bluebeast
cd bluebeast/
```

3. Build vagrant vm

```sh
sudo vagrant up --provision
```

4. Run

```sh
vagrant ssh
cd build
./build.sh
```