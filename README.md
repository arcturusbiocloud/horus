Horus
=====

This project is responsible for manage the robots across the Arcturus BioCloud cluster in a distributed fashion.
We can use `Horus.Client` on the master node to manage processes and output streams in the remote nodes.
Basically when a experiment is started, the Horus responsibility is ask to the cluster which robot is available to do the experiment and start the live streaming, the python process responsible to move the pipette and the interface with the OpenPCR storage device.


## Feature Roadmap

  - [x] external process control
  - [x] node monitoring and auto reconnect
  - [ ] serial port interface
  - [ ] storage device interface
  - [ ] robot syntax sugar
  

## How to start
On the `Horus.Client` side add the `Horus` to your mix.exs deps but don't add to the application list. Start your main application using the configuration of node ports, cookie and name bellow:

    elixir --erl "-kernel inet_dist_listen_min 9100 -kernel inet_dist_listen_max 9115" --no-halt --cookie qeSwOMmQ+BFt3cMjf1kazeIMRwhy45ySlbvFCuWsRcU= --name "isis@osiris.arcturus.io" -S mix
    
See the `test/horus_text.exs` to learn how to use the `Horus.Client`
    
On the `Horus.Server` side clone the repository and start with:

    elixir --no-halt --name "horus@osiris.arcturus.io" -S mix
  

## Requirements

### How to install Elixir on BeagleBone black
    
    sudo vim /etc/apt/sources.list
    deb http://ftp.debian.org/debian wheezy-backports main contrib non-free

    sudo apt-get update

    locale-gen en_US.UTF-8

    vim .bashrc
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US:en
    export LC_ALL=en_US.UTF-8

    apt-get install -t wheezy-backports erlang

    wget https://github.com/elixir-lang/elixir/archive/v1.0.2.tar.gz
    tar -zxvf v1.0.2.tar.gz
    cd elixir-1.0.2
    make clean test
    sudo make install

    vim .bashrc
    export PATH="$PATH:/root/elixir-1.0.2/bin"
    
![Horus] (http://0.tqn.com/y/altreligion/1/S/6/2/-/-/eye-of-horus-tri.jpg)
    
