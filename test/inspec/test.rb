# test for os package
describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
  its('processes') {should include 'nginx'}
end