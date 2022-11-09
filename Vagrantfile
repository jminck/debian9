# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "generic/debian9"
  config.vm.provider "virtualbox"
  config.vm.network "private_network", ip: "192.168.33.10"
  #ingress NIC
  config.vm.network "public_network", type: "dhcp", bridge: "Intel(R) I211 Gigabit Network Connection #4"
  #egress NIC
  config.vm.network "public_network", type: "dhcp", bridge: "Intel(R) I211 Gigabit Network Connection #2"

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = false
    vb.gui = true
    vb.name = "debian9"
    vb.memory = "2048"
    vb.customize ['modifyvm', :id, '--nicpromisc1', 'allow-all' ]
    vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all' ]
    vb.customize ['modifyvm', :id, '--nicpromisc3', 'allow-all' ]
    vb.customize ['modifyvm', :id, '--nicpromisc4', 'allow-all' ]
  end

  config.vm.provision "shell", inline: <<-SHELL
    egress="eth2"
    ingress="eth3"
    sudo apt update
    sudo apt install openssh-server
    sudo su
    apt install bridge-utils
    apt install vim
    ip link show
    
    ip link add br0 type bridge
    ip link set $ingress up
    ip link set $egress up
    ip link set br0 up
    ip link set dev $ingress master br0
    ip link set dev $egress master br0
    ip link show

    echo auto br0 >> /etc/network/interfaces
    echo iface br0 inet manual >> /etc/network/interfaces
    echo bridge_ports $ingress $egress  >> /etc/network/interfaces
    echo bridge_stp on  >> /etc/network/interfaces

    #script samples for traffic control tools

    #latency 
    echo sudo tc qdisc add dev $ingress root netem delay 30ms > add-30ms-ingress-delay.sh
    echo sudo tc qdisc add dev $egress root netem delay 30ms > add-30ms-egress-delay.sh
    echo sudo tc qdisc add dev $ingress root netem delay 70ms > add-70ms-ingress-delay.sh
    echo sudo tc qdisc add dev $egress root netem delay 70ms > add-70ms-egress-delay.sh
    echo \#1000ms delay with +- 10ms of jitter >100ms-ingress-delay-with+-10ms-dist.sh
    echo sudo tc qdisc add dev $ingress root netem delay 100ms 20ms distribution normal >>100ms-ingress-delay-with+-10ms-dist.sh
    echo \#1000ms delay with +- 10ms of jitter >100ms-ingress-delay-with+-10ms-dist.sh
    echo sudo tc qdisc add dev $egress root netem delay 500ms 500ms distribution normal >>500ms-egress-delay-with+-250ms-dist.sh

    #bw limit 
    echo sudo tc qdisc add dev $egress root tbf rate 1mbit burst 32kbit latency 400ms  > limit-egress-bw-3mb-drop-latent-packets.sh

    #dupe packets
    echo sudo tc qdisc add dev $ingress root netem duplicate 1\% > dupe-1pct-ingress-packets.sh

    #packet loss
    echo sudo tc qdisc add dev $ingress root netem loss 2\% > 2pct-ingress-packet-loss.sh 
    echo sudo tc qdisc add dev $egress root netem loss 5\% > 5pct-egress-packet-loss.sh 
  
    #packet corruption
    echo sudo tc qdisc add dev $ingress root netem corrupt 1\% > corrupt-1pct-ingress-packets.sh
    echo sudo tc qdisc add dev $ingress root netem corrupt 5\% > corrupt-5pct-ingress-packets.sh

    #show current rules
    echo echo ingress  > show-impairments.sh
    echo sudo tc -s qdisc show dev $ingress >> show-impairments.sh
    echo echo egress  >> show-impairments.sh
    echo sudo tc -s qdisc show dev $egress  >> show-impairments.sh

    #remove all rules
    echo echo ingress > remove-all-rules.sh
    echo sudo tc qdisc del dev $ingress root netem \2\>/dev/null \|\| true >> remove-all-rules.sh
    echo sudo tc qdisc del dev $ingress root \2\>/dev/null \|\| true >> remove-all-rules.sh
    echo sudo tc qdisc add dev $egress root pfifo \2\>/dev/null \|\| true >> remove-all-rules.sh
    echo echo  egress >> remove-all-rules.sh
    echo sudo tc qdisc del dev $egress root netem \2\>/dev/null \|\| true >> remove-all-rules.sh
    echo sudo tc qdisc del dev $ingress root \2\>/dev/null \|\| true >> remove-all-rules.sh
    echo sudo tc qdisc add dev $egress root pfifo \2\>/dev/null \|\| true >> remove-all-rules.sh
    chmod +x *sh



  SHELL
end
