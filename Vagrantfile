Vagrant.configure('2') do |config|
  config.vm.box = 'hashicorp/bionic64'

  $dns_script = <<-'SCRIPT'
  sudo apt update -y
  sudo apt upgrade -y
  echo "nameserver 172.30.0.3" > /etc/resolv.conf
  SCRIPT

  $ansible_script = <<-'SCRIPT'
  sudo apt install ansible -y
  SCRIPT

  (0..2).each do |i|
    config.vm.define "kubernetes-master-#{i}" do |master|
      master.vm.hostname = "kubernetes-master-#{i}"
      master.vm.network 'private_network', ip: "10.200.100.1#{i}"
      master.vm.provision 'shell', inline: $dns_script, run: "always"
      master.vm.provider 'virtualbox' do |vb|
        vb.name = "kubernetes-master-#{i}"
        vb.memory = 8000
        vb.cpus = 4
        vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      end
    end
  end

  (0..2).each do |i|
    config.vm.define "kubernetes-worker-#{i}" do |worker|
      worker.vm.hostname = "kubernetes-worker-#{i}"
      worker.vm.network 'private_network', ip: "10.200.100.2#{i}"
      worker.vm.provision 'shell', inline: $dns_script, run: "always"
      worker.vm.provider 'virtualbox' do |vb|
        vb.name = "kubernetes-worker-#{i}"
        vb.memory = 8000
        vb.cpus = 4
        vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      end
    end
  end

  config.vm.define 'kubernetes-deployer' do |deployer|
    deployer.vm.hostname = 'kubernetes-deployer'
    deployer.vm.network 'private_network', ip: '10.200.200.30'
    deployer.vm.provision 'shell', inline: $dns_script, run: "always"
    deployer.vm.provision 'shell', inline: $vagrant_script
    deployer.vm.provider 'virtualbox' do |vb|
      vb.name = 'kubernetes-deployer'
      vb.memory = 4000
      vb.cpus = 2
    end
  end
end
