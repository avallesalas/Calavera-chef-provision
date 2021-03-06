# final production build
# Add jenkins to automate deployment
include_recipe "brazos::default"

#execute "apt-get-update-periodic" do
  #command "apt-get update"
  #ignore_failure true
  ##only_if do
    ##File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    ##File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  ##end
#end

package 'tomcat6'
#For docker phusion images to work
file "/etc/my_init.d/tomcat6" do
  content "#!/bin/bash
export PATH=/usr/lib/jvm/java-7-openjdk-amd64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
/etc/init.d/tomcat6 start || exit 0

"
  mode '0755'
end


package "wget"

["/var/lib/tomcat6/webapps/ROOT/WEB-INF/",
 "/var/lib/tomcat6/webapps/ROOT/WEB-INF/lib"].each do | name |

  directory name  do
    mode 00755
    action :create
    recursive true
  end
end

# Let that for later
#remote_file "/var/lib/tomcat6/webapps/ROOT/WEB-INF/lib/CalaveraMain.jar" do
  #source "http://espina:8081/artifactory/simple/ext-release-local/Calavera/target/CalaveraMain.jar"
  #mode '0755'
  #checksum "3a7dac00b1" # A SHA256 (or portion thereof) of the file.
#end

#remote_file "/var/lib/tomcat6/webapps/ROOT/WEB-INF/web.xml" do
  #source "http://espina:8081/artifactory/simple/ext-release-local/Calavera/target/web.xml"
  #mode '0755'
  #checksum "3a7dac00b1" # A SHA256 (or portion thereof) of the file.
#end

#cookbook_file "deploy.sudo" do
  #path "/etc/sudoers.d/deploy"
  #mode 0755
  #user "root"
  #group "root"
  #action :create
#end



#service "tomcat6" do
  #action :restart
#end
