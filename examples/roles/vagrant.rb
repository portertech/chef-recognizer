name "vagrant"
description "Role for testing Recognizer"
run_list("recipe[recognizer]")

override_attributes :recognizer => {
  :librato => {
    :email => "email@example.com",
    :api_key => "706325cf16d84d098127e143221dd180706325cf16d84d098127e143221dd180"
  }
}
