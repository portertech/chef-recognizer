#
# Cookbook Name:: recognizer
# Library:: json_file
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

class Chef::Provider::JsonFile < Chef::Provider::File
  def load_json(path)
    JSON.load(::File.read(path)) rescue nil
  end

  def dump_json(obj)
    JSON.pretty_generate(obj) + "\n"
  end

  def compare_content
    load_json(@current_resource.path) == @new_resource.content
  end

  def set_content
    unless compare_content
      backup @new_resource.path if ::File.exists?(@new_resource.path)
      ::File.open(@new_resource.path, "w") {|f| f.write dump_json(@new_resource.content) }
      Chef::Log.info("#{@new_resource} updated file #{@new_resource.path}")
      @new_resource.updated_by_last_action(true)
    end
  end

  def action_create
    set_content unless @new_resource.content.nil?
    set_owner unless @new_resource.owner.nil?
    set_group unless @new_resource.group.nil?
    set_mode unless @new_resource.mode.nil?
  end
end

class Chef::Resource::JsonFile < Chef::Resource::File
  attribute :content, :kind_of => Hash

  def initialize(name, run_context=nil)
    super
    @resource_name = :json_file
  end
end
