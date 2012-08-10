#
# Cookbook Name:: recognizer
# Recipe:: default
#
# Copyright 2012, Sean Porter Consulting
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

recognizer_config node.name

template "/etc/init/recognizer.conf" do
  source "upstart.erb"
  variables(
    :directory => node.recognizer.jar.directory,
    :user => node.recognizer.user,
    :command => "java -jar recognizer.jar -c #{node.recognizer.directory}/config.json",
    :log_file => "#{node.recognizer.log.directory}/service.log"
  )
  mode 0644
end

service "recognizer" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
  subscribes :restart, resources(:recognizer_config => node.name, :execute => "extract_recognizer_jar"), :delayed
end
