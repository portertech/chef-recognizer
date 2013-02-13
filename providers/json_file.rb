#
# Cookbook Name:: recognizer
# Provider:: json_file
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

def load_json(path)
  JSON.parse(::File.read(path)) rescue Hash.new
end

def dump_json(obj)
  JSON.pretty_generate(obj) + "\n"
end

def to_mash(obj)
  Mash.from_hash(obj)
end

def compare_content(path, content)
  to_mash(load_json(path)) == to_mash(content)
end

action :create do
  unless compare_content(new_resource.path, new_resource.content)
    file new_resource.path do
      mode new_resource.mode
      content dump_json(new_resource.content)
      notifies :restart, 'service[recognizer]', :delayed
    end
  end
end
