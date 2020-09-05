Vagrant.configure('2') do |config|
  config.vm.box = 'hashicorp/bionic64'

  ### uncomment this to add custom DNS to your VM
  $dns_script = <<-'SCRIPT'
  echo "nameserver 172.30.0.3" > /etc/resolv.conf
  SCRIPT

  $ansible_script = <<-'SCRIPT'
  sudo apt update -y
  sudo apt install ansible sshpass -y
  SCRIPT

  ### cluster name configuration
  ### configure this also in the group_vars/all.yml and hosts/hosts
  cluster_name = "kubernetes-cluster-01"

  ### cluster network configuration
  ### configure this also in the group_vars/all.yml and hosts/hosts

  ### currently only support /24
  ### please provide only the network section
  ### TODO: make this more configurable
  cluster_network = "10.200.100"

  (0..2).each do |i|
    config.vm.define "#{cluster_name}-master-#{i}" do |master|
      master.vm.hostname = "#{cluster_name}-master-#{i}"
      master.vm.provision 'shell', inline: "echo '#{cluster_network}.1#{i} #{cluster_name}-master-#{i}' > /etc/hosts"
      master.vm.network 'private_network', ip: "#{cluster_network}.1#{i}"

      ### uncomment this to add custom DNS to your VM
      # master.vm.provision 'shell', inline: $dns_script, run: "always"

      ### uncomment this to add host public ssh key to your VM
      ### you need to have the public ssh key in ~/.ssh/id_rsa.pub 
      # master.vm.provision "shell" do |s|
      #   ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      #   s.inline = <<-SHELL
      #     echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      #   SHELL
      # end
      
      ### Uncomment this if you need to add self signed CA to trust
      ### you need to install vagrant plugin
      ### vagrant plugin install vagrant-certificates
      # master.certificates.enabled = true
      # master.certificates.certs = Dir.glob('../../template/ca/root-cert.pem')

      master.vm.provider 'virtualbox' do |vb|
        vb.name = "#{cluster_name}-master-#{i}"
        vb.memory = 2048
        vb.cpus = 2
        vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      end
    end
  end

  (0..2).each do |i|
    config.vm.define "#{cluster_name}-worker-#{i}" do |worker|
      worker.vm.hostname = "#{cluster_name}-worker-#{i}"
      worker.vm.network 'private_network', ip: "#{cluster_network}.2#{i}"
      worker.vm.provision 'shell', inline: "echo '#{cluster_network}.2#{i} #{cluster_name}-worker-#{i}' > /etc/hosts"

      ### uncomment this to add custom DNS to your VM
      # worker.vm.provision 'shell', inline: $dns_script, run: "always"

      ### uncomment this to add host public ssh key to your VM
      ### you need to have the public ssh key in ~/.ssh/id_rsa.pub 
      # worker.vm.provision "shell" do |s|
      #   ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      #   s.inline = <<-SHELL
      #     echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      #   SHELL
      # end

      ### Uncomment this if you need to add self signed CA to trust
      ### you need to install vagrant plugin
      ### vagrant plugin install vagrant-certificates
      # worker.certificates.enabled = true
      # worker.certificates.certs = Dir.glob('../../template/ca/root-cert.pem')

      worker.vm.provider 'virtualbox' do |vb|
        vb.name = "#{cluster_name}-worker-#{i}"
        vb.memory = 4096
        vb.cpus = 4
        vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      end
    end
  end

  config.vm.define "#{cluster_name}-deployer" do |deployer|
    deployer.vm.hostname = "#{cluster_name}-deployer"
    deployer.vm.network 'private_network', ip: "#{cluster_network}.30"
    deployer.vm.provision 'shell', inline: "echo '#{cluster_network}.30 #{cluster_name}-deployer' > /etc/hosts"
          
    ### uncomment this to add custom DNS to your VM
    # deployer.vm.provision 'shell', inline: $dns_script, run: "always"

    ### uncomment this to add host public ssh key to your VM
    ### you need to have the public ssh key in ~/.ssh/id_rsa.pub 
    # deployer.vm.provision "shell" do |s|
    #   ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    #   s.inline = <<-SHELL
    #     echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
    #   SHELL
    # end

    ### Uncomment this if you need to add self signed CA to trust
    ### you need to install vagrant plugin
    ### vagrant plugin install vagrant-certificates
    # deployer.certificates.enabled = true
    # deployer.certificates.certs = Dir.glob('../../template/ca/root-cert.pem')

    deployer.vm.provision 'shell', inline: $ansible_script
    deployer.vm.provider 'virtualbox' do |vb|
      vb.name = "#{cluster_name}-deployer"
      vb.memory = 1024
      vb.cpus = 2
    end
  end
end
