#! /usr/bin/env/ruby
require 'chef/provisioning/docker_driver'
with_driver 'docker'

# global variables
chef_env = '_default'
domain = 'calavera.biz'
subdomain = "#{domain}"

execute "zerohosts" do
   command "> /opt/Calavera-chef-provision/dnsmasq.hosts/calavera.biz"
end

%w{cerebro brazos espina hombros manos cara}.each do |hname|

    machine "#{hname}.#{domain}" do
      action :stop
    end
end

execute "reload dnsmasq" do
  command "docker kill -s HUP dnsmasq"
end
