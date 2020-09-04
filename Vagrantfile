Vagrant.configure('2') do |config|
  config.vm.box = 'hashicorp/bionic64'

  ### uncomment this to add custom DNS to your VM
  # $dns_script = <<-'SCRIPT'
  # echo "nameserver 172.30.0.3" > /etc/resolv.conf
  # SCRIPT

  $ansible_script = <<-'SCRIPT'
  sudo apt update -y
  sudo apt install ansible sshpass -y
  SCRIPT

  (0..2).each do |i|
    config.vm.define "kubernetes-master-#{i}" do |master|
      master.vm.hostname = "kubernetes-master-#{i}"
      master.vm.provision 'shell', inline: "echo '10.200.100.1#{i} kubernetes-master-#{i}' > /etc/hosts"
      master.vm.network 'private_network', ip: "10.200.100.1#{i}"

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
        vb.name = "kubernetes-master-#{i}"
        vb.memory = 2048
        vb.cpus = 2
        vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      end
    end
  end

  (0..2).each do |i|
    config.vm.define "kubernetes-worker-#{i}" do |worker|
      worker.vm.hostname = "kubernetes-worker-#{i}"
      worker.vm.network 'private_network', ip: "10.200.100.2#{i}"
      worker.vm.provision 'shell', inline: "echo '10.200.100.2#{i} kubernetes-worker-#{i}' > /etc/hosts"

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
        vb.name = "kubernetes-worker-#{i}"
        vb.memory = 4096
        vb.cpus = 4
        vb.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      end
    end
  end

  config.vm.define 'kubernetes-deployer' do |deployer|
    deployer.vm.hostname = 'kubernetes-deployer'
    deployer.vm.network 'private_network', ip: '10.200.100.30'
    deployer.vm.provision 'shell', inline: "echo '10.200.100.30 kubernetes-deployer' > /etc/hosts"
          
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
      vb.name = 'kubernetes-deployer'
      vb.memory = 1024
      vb.cpus = 2
    end
  end
end
