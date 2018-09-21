# test for os package
describe package('nginx') do
  it { should be_installed }
end

# test that nginx package is running
describe service('nginx') do
  it { should be_running }
end

# test that HTTP port is listened to by nginx
describe port(80) do
  it { should be_listening }
  its('processes') {should include 'nginx'}
end