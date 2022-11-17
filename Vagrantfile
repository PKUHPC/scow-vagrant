# 创建要创建的虚拟机清单
vm_list = [
    {
        :name => "slurm",
        :eth1 => "192.168.88.101",
        :mem => "4096",
        :cpu => "2",
        :sshport => 22231,
        :box => "icode/slurm",
		    :role => "slurm",
        :is_service_node => true
    },
    {
        :name => "login",
        :eth1 => "192.168.88.102",
        :mem => "4096",
        :cpu => "2",
        :sshport => 22232,
        :box => "icode/slurm_compute",
		    :role => "slurm",
        :is_service_node => false
    },  
    {
        :name => "cn01",
        :eth1 => "192.168.88.103",
        :mem => "8192",
        :cpu => "4",
        :sshport => 22233,
        :box => "icode/slurm_compute",
		    :role => "slurm",
        :is_service_node => false
    },
	  {
        :name => "scow",
        :eth1 => "192.168.88.100",
        :mem => "8192",
        :cpu => "4",
        :sshport => 22288,
        :box => "icode/scow",
		    :role => "scow",
        :is_service_node => false
    }

]


Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  Encoding.default_external = 'UTF-8'

  vm_list.each do |item|
    config.vm.define item[:name] do |vm_config|
      vm_config.vm.box = item[:box]
      vm_config.vm.hostname = item[:name]
      vm_config.vm.network "private_network", ip: item[:eth1]

      # 禁用掉默认的SSH服务转发端口
      vm_config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: "true"
      vm_config.vm.network "forwarded_port", guest: 22, host: item[:sshport]

      vm_config.vm.provider "virtualbox" do |vb|
        vb.memory = item[:mem];
        vb.cpus = item[:cpu];
        vb.name = item[:name];
      end

      # 添加hosts
      vm_config.vm.provision "shell", inline: "sed -i '$d' /etc/hosts"
      vm_list.each do |it|
          vm_config.vm.provision "shell", inline: "echo " + it[:eth1] + "    " + it[:name] + " >> /etc/hosts"
      end
      

      if item[:role]=="slurm"
        
        vm_config.vm.provision "shell", path: "scripts/munge.sh"
        if item[:is_service_node]
            #vm_config.vm.provision "shell", path: "scripts/mariadb.sh"
            vm_config.vm.provision "shell", path: "scripts/slurm_server.sh"
            vm_config.vm.provision "shell", path: "scripts/nfs_server.sh"
            vm_config.vm.provision "shell", path: "scripts/ldap_server.sh"
            vm_config.vm.provision "shell", inline: "ssystemctl restart slapd"
            vm_config.vm.provision "shell", inline: "sleep 5s"
            vm_config.vm.provision "shell", inline: "ldapadd -x -D cn=Manager,$OU,$DN -w $adminPasswd -f /vagrant/slurm/demo_admin.ldif"
            
        else
            vm_config.vm.provision "shell", path: "scripts/slurm_client.sh"
            vm_config.vm.provision "shell", path: "scripts/nfs_client.sh"
            vm_config.vm.provision "shell", path: "scripts/ldap_client.sh"
        end                     

      elsif item[:role]=="scow"
        vm_config.vm.provision "shell", inline: "ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''"
        vm_list.each do |it|
          vm_config.vm.provision "shell", inline: "sshpass -pvagrant ssh-copy-id -o StrictHostKeyChecking=no "+ it[:eth1]               
        end
        vm_config.vm.provision "shell", path: "scripts/scow.sh"
    
      else
        vm_config.vm.provision "shell", inline: "echo 主机角色设置有误："+ item[:slurm] 

      end

    end
  end
end
