VAGRANTFILE_API_VERSION = "2"

cluster = {
  "master1" => { :ip => "192.168.33.10", :cpus => 1, :mem => 1024 },
  "master2" => { :ip => "192.168.33.11", :cpus => 1, :mem => 1024 },
  "master3" => { :ip => "192.168.33.12", :cpus => 1, :mem => 1024 },
}
 
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  cluster.each_with_index do |(hostname, info), index|

    config.vm.define hostname do |cfg|
      cfg.vm.provider :virtualbox do |vb, override|
        config.vm.box = "bento/centos-7.4"
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on"]
        config.vm.synced_folder ".", "/vagrant_data"
	config.vm.provision :shell, :path => "etcd_init.sh"
      end # end provider
    end # end config

  end # end cluster
end
