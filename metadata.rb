name             "recognizer"
maintainer       "Sean Porter Consulting"
maintainer_email "portertech@gmail.com"
license          "MIT"
description      "Installs/Configures Recognizer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.7"

# available @ http://community.opscode.com/cookbooks/apt
depends "apt"

# available @ http://community.opscode.com/cookbooks/java
depends "java"

%w[
  ubuntu
].each do |os|
  supports os
end
