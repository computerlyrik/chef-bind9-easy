default['bind9-easy']['id'] = {}

default['bind9-easy']['forward'] = []
default['bind9-easy']['transfer'] = []
default['bind9-easy']['trusted_server'] = []
default['bind9-easy']['package'] = 'bind9'

case node["platform"]
when "debian", "ubuntu"
   default['bind9-easy']['service'] = 'bind9'
when "redhat", "centos", "fedora"
   default['bind9-easy']['service'] = 'named'
end
