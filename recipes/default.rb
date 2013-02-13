#
# Cookbook Name:: recognizer
# Recipe:: default
#
# Copyright 2012-2013, Sean Porter Consulting
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe "recognizer::jar"

directory node.recognizer.directory do
  recursive true
end

user node.recognizer.user do
  home node.recognizer.directory
  system true
end

directory node.recognizer.log.directory do
  owner node.recognizer.user
  mode 0755
end

config_file = File.join(node.recognizer.directory, "config.json")

recognizer_config = node.recognizer.to_hash.reject do |key, value|
  %w[version user directory log jar].include?(key)
end

recognizer_json_file config_file do
  content recognizer_config
  mode 0644
end

max_heap = node.recognizer.jar.max_heap

template "/etc/init/recognizer.conf" do
  source "upstart.erb"
  variables(
    :cwd => node.recognizer.jar.directory,
    :user => node.recognizer.user,
    :command => "java -Xmx#{max_heap} -Xms#{max_heap} -jar recognizer.jar -c #{config_file}",
    :log_file => "#{node.recognizer.log.directory}/service.log"
  )
  mode 0644
end

service "recognizer" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
  subscribes :restart, resources(:execute => "extract_recognizer_jar"), :delayed
end
