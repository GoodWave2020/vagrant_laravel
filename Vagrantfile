# -*- mode: ruby -*-
# vi: set ft=ruby :
Dotenv.load

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.2"
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false  
  end
  config.vm.network "forwarded_port", guest: 80, host: ENV['HOST_HTTP_PORT']
  config.vm.network "private_network", ip: "#{ENV['PRIVATE_IP']}"
  # config.vm.network "public_network", ip: "#{ENV['PUBLIC_IP']}", bridge: ENV['BRIDGE_INTERFACE']
  # ソースファイルの同期
  config.vm.synced_folder "./src", "/home/vagrant/src", :mount_options => ['dmode=777', 'fmode=777']
  # プロビジョン時に使用するファイル群の同期
  config.vm.synced_folder "./provision", "/home/vagrant/provision", :mount_options => ['dmode=777', 'fmode=777']
  # nginxの設定ファイル同期
  config.vm.synced_folder "./conf/nginx", "/etc/nginx/conf.d"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    # ボックス名を指定。
    vb.name   = "vagrant-laravel"
    # メモリを指定
    vb.memory = "2048"
  end
  # 仮想環境作成時に実行するシェル
  config.vm.provision "shell", :path => "./provision/provision.sh", :privileged => true
  # 起動時に毎回実行するシェル
  config.vm.provision "shell", run: "always", :path => "boot.sh", :privileged => true
end
