![Horus] (http://0.tqn.com/y/altreligion/1/S/6/2/-/-/eye-of-horus-tri.jpg)
=========

Horus
=====

This project is responsible for manage the robots across the Arcturus BioCloud cluster in a distributed fashion.
We can use Horus.Client on the master node to manage processes and output streams in the remote nodes.
Basically when a experiment is started, the Horus responsibility is ask to the cluster which robot is available to do the experiment and start the lives streaming, the python process responsible to move the pipette and the interface with the OpenPCR storage device.
