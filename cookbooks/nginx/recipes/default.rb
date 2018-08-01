yum_package 'epel-release' do
end

package 'nginx' do
end

cookbook_file '/usr/share/nginx/html/index.html' do
    source 'index.html'
end

cookbook_file '/usr/share/nginx/html/hello-nurse.jpg' do
  source 'hello-nurse.jpg'
end

cookbook_file '/etc/nginx/nginx.conf' do
    source 'nginx.conf'
end

service 'nginx' do
    supports status: true, restart: true, reload: true
    action [:start, :enable]
end