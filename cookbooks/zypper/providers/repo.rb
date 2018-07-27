require 'mixlib/shellout'

use_inline_resources

def whyrun_supported?
  true
end

action :add do
  unless repo_exist?
    converge_by("add zypper repository '#{new_resource.repo_name}'") do
      unless new_resource.key.nil?
        install_curl
        import_key
      end
      command = 'zypper ar'
      command << ' -f' if new_resource.autorefresh
      command << " #{new_resource.uri} \"#{new_resource.repo_name}\""
      shellout = Mixlib::ShellOut.new(command, user: 'root').run_command
      if shellout.stderr.empty?
        set_priority
      else
        Chef::Log.error("Error adding repo: #{shellout.stderr}")
      end
    end
  end
end

action :remove do
  if repo_exist?
    converge_by("remove zypper repository '#{new_resource.repo_name}'") do
      command = "zypper rr \"#{new_resource.repo_name}\""
      shellout = Mixlib::ShellOut.new(command, user: 'root').run_command
      Chef::Log.error("Error removing repo: #{shellout.stderr}") unless shellout.stderr.empty?
    end
  end
end

def repo_exist?
  command = "zypper repos | grep \"#{new_resource.repo_name}\""
  shellout = Mixlib::ShellOut.new(command, user: 'root').run_command
  if shellout.stdout.empty?
    false
  else
    true
  end
end

def install_curl
  # Make sure curl is installed
  pkg = Chef::Resource::Package.new('curl', run_context)
  pkg.run_action :install
end

def import_key
  cmd = Chef::Resource::Execute.new("import key for #{new_resource.repo_name}",
                                run_context)
  cmd.command "rpm --import #{new_resource.key}"
  cmd.run_action :run
end

def set_priority
  return if new_resource.priority.nil? || new_resource.priority <= 0
  command = 'zypper mr'
  command << " -p #{new_resource.priority} \"#{new_resource.repo_name}\""
  shellout = Mixlib::ShellOut.new(command, user: 'root').run_command
  Chef::Log.error("Error setting repo priority: #{shellout.stderr}") unless shellout.stderr.empty?
end
