# set up central git repository server

#execute "apt-get-update-periodic" do
  #command "apt-get update"
  #ignore_failure true
  ##only_if do
    ##File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    ##File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  ##end
#end

package 'git'

group 'vagrant' do
  gid '1000'
end
group 'git' do
  gid '1003'
end

group 'jenkins' 

user 'vagrant' do
  group 'git'
  uid '1000'
  password "*"
  action [:create,:unlock]
end

user 'git' do
  group 'git'
  uid '1003'
  password "*"
  action [:create,:unlock]
end

user 'jenkins' do   # jenkins will need to ssh in to retrieve files to build
  group 'jenkins'
  group 'git'
  password "*"
  action [:create,:unlock]
end

directory "/home/hijo.git/"  do
    mode 00775
    owner "git"
    group "git"
    action :create
    recursive true
end

directory "/home/jenkins/.ssh"  do
    mode 00700      # this will fail with other permissions
    owner "jenkins"
    group "git"
    action :create
    recursive true
end

execute 'Jenkins keys' do
  cwd '/home/vagrant/shared/keys/'
  command 'cp * /home/jenkins/.ssh'  # this should include authorized keys. 
end

execute 'correct Jenkins ssh files ownership' do
  command 'chown -R jenkins /home/jenkins &&  \
          chgrp -R jenkins /home/jenkins'  
end

   

execute 'init git' do
  user "git"
  group "git"
  command 'git init --bare --shared=group /home/hijo.git'
end

execute 'init git' do
  user "git"
  group "git"
  cwd '/home/hijo.git'
  command "git config receive.denynonfastforwards false"    # this way we can force wipe from manos if manos is rebuilt after cerebro
end
#configure post receive hook
# that means manos is dependent on havng cerebro done in terms of ordering

cookbook_file "post-receive" do
    path "/home/hijo.git/hooks/post-receive"
    user "jenkins"
    group "jenkins"
    mode 00755    # must be executable
    action :create
end
