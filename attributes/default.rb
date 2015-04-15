default['bind9-easy']['id'] = {}

default['bind9-easy']['forward'] = []
default['bind9-easy']['transfer'] = []
default['bind9-easy']['trusted_server'] = []


case node["platform"]
when "debian", "ubuntu"
   default['bind9-easy']['service'] = 'bind9'
   default['bind9-easy']['package'] = 'bind9'
   default['bind9-easy']['config_dir'] = '/etc/bind'
   default['bind9-easy']['usergroup'] = 'bind'
   default['bind9-easy']['rfc1918'] = '/etc/bind/zones.rfc1918'
when "redhat", "centos", "fedora"
   default['bind9-easy']['service'] = 'named'
   default['bind9-easy']['package'] = 'bind'
   default['bind9-easy']['config_dir'] = '/etc/named'
   default['bind9-easy']['usergroup'] = 'named'
   default['bind9-easy']['rfc1918'] = '/etc/named.rfc1912.zones'
end
