servers = [
    {
        :name => "kmaster",
        :type => "master",
        :box => "bento/ubuntu-20.04",
        # :box_version => "20180831.0.0",
        :eth1 => "192.168.56.10",
        :mem => "2048",
        :cpu => "2",
        :size => "20GB"
    },
    {
        :name => "node-1",
        :type => "node",
        :box => "bento/ubuntu-20.04",
        # :box_version => "20180831.0.0",
        :eth1 => "192.168.56.11",
        :mem => "1024",
        :cpu => "2",
        :size => "20GB"
    },
    {
        :name => "node-2",
        :type => "node",
        :box => "bento/ubuntu-20.04",
        # :box_version => "20180831.0.0",
        :eth1 => "192.168.56.12",
        :mem => "1024",
        :cpu => "2",
        :size => "20GB"
    }
]


Vagrant.configure("2") do |config|

  servers.each do |opts|
      config.vm.define opts[:name] do |config|

          config.vm.box = opts[:box]
          config.vm.hostname = opts[:name]
          

          config.vm.provider "virtualbox" do |v|

              v.name = opts[:name]
              # v.customize ["modifyvm", :id, "--groups", "/Ballerina Development"]
              v.customize ["modifyvm", :id, "--memory", opts[:mem]]
              v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]

          end

          #DHCP — comment this out if planning on using NAT instead
          # config.vm.network "private_network", type: "dhcp"

          # Port forwarding — uncomment this to use NAT instead of DHCP
          # config.vm.network "forwarded_port", guest: 80, host: VM_PORT

          config.vm.network "private_network", ip: opts[:eth1]

          # we cannot use this because we can't install the docker version we want - https://github.com/hashicorp/vagrant/issues/4871
          #config.vm.provision "docker"

          # config.vm.provision "shell", inline: $configureBox

          config.vm.provision "shell", path: "scripts/common.sh"
          

          if opts[:type] == "master"
            config.vm.provision "shell", path: "scripts/master.sh"
          else
            config.vm.provision "shell", path: "scripts/worker.sh"
          end

      end

  end

end 
