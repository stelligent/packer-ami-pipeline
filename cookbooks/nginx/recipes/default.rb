# Pull down EPEL repo
remote_file "/tmp/epel-release-latest-7.noarch.rpm" do
    source "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
    owner 'root'
    group 'root'
    mode 0755
end

# Install epel-release package
package 'epel-release' do
    source "/tmp/epel-release-latest-7.noarch.rpm"
    action :install
end

# Install nginx package
package 'nginx' do
end

# Copy index.html file to web root
cookbook_file '/usr/share/nginx/html/index.html' do
    source 'index.html'
end

# Copy image to web root
cookbook_file '/usr/share/nginx/html/hello-nurse.jpg' do
  source 'hello-nurse.jpg'
end

# Copy nginx.conf to /etc/nginx
cookbook_file '/etc/nginx/nginx.conf' do
    source 'nginx.conf'
end

# Ensure nginx service is started and enabled
service 'nginx' do
    supports status: true, restart: true, reload: true
    action [:start, :enable]
end