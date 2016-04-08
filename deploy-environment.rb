#! /usr/bin/env/ruby
# Deploy a database server, two app servers, and a load balancer
require 'chef/provisioning/docker_driver'

# global variables
chef_env = '_default'
domain = 'calavera.biz'
#subdomain = "#{chef_env}.#{domain}"
subdomain = "#{domain}"

# Dev/Non-Prod instance count
#num_appservers = 2
#num_dbservers = 1

# Conditional deployment
#if chef_env.eql?("production")
  #num_appservers = 3
  #num_dbservers = 2
#end

# DB server(s)
# Standby DB could be configured as such after finding online Active node
# One method would be to add to a recipe search(:node, 'recipes:"postgresql::server"')
#1.upto(num_dbservers) do |i|
  machine_image "espinav2" do

    recipe  "base::default"
    recipe  "shared::default"
    recipe  "java7::default"
    recipe  "espina::default"
    # FROM phusion/baseimage:0.9.16
    chef_environment chef_env
      machine_options :docker_options => {
        :base_image => {
          :name => 'phusion/baseimage',
          :repository => 'phusion',
          :tag => '0.9.16'
        },

        :volumes => ["/opt/Calavera-chef:/home/vagrant","/opt/Calavera-chef:/home/espina","/opt/Calavera-chef/shared:/mnt/shared"]

      }
#    action :destroy
  end
  
  #machine "espina.#{domain}" do
      #from_image 'espina'
#
      #machine_options :docker_options => {
        #:volumes => ["/opt/Calavera-chef:/home/vagrant","/opt/Calavera-chef:/home/espina","/opt/Calavera-chef/shared:/mnt/shared"],
        #:command => '/sbin/my_init'
      #}
  #end
#end

# Launch Application servers in parallel
#machine_batch do
  #1.upto(num_appservers) do |i|
    #machine "app#{i}.#{domain}" do
      #recipe 'apt::default' # Update local apt database
      #recipe 'tomcat'
      #chef_environment chef_env
      #attribute 'tomcat', { 'base_version' => 7 } # sets node['tomcat']['base_version']
      #attribute 'java', { 'java_home' => '/usr/lib/jvm/java-1.7.0-openjdk-amd64' } # sets node['java']['java_home']
      #machine_options :docker_options => {
        #:base_image => {
        #:name => 'ubuntu',
        #:repository => 'ubuntu',
        #:tag => '14.04'
        #},
        #:command => 'service tomcat7 start'
      #}
    #end
  #end
#end

## Load balancer
#machine "lb1.#{domain}" do
  #recipe 'haproxy'
  #chef_environment chef_env
  #machine_options :docker_options => {
      #:base_image => {
      #:name => 'ubuntu',
      #:repository => 'ubuntu',
      #:tag => '14.04'
    #},
    #:command => 'service haproxy start'
  #}
##end
