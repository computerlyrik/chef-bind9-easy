default['bind9-easy']['domain'] = node['domain']
default['bind9-easy']['nameservers'] = ["ns.#{node['domain']}"]
default['bind9-easy']['hostmaster_email'] = "hostmaster.#{node['bind9-easy']['domain']}"

# default['bind9-easy']['@'] = "mail.#{node['bind9-easy']['domain']}"
default['bind9-easy']['mailserver'] = "mail.#{node['bind9-easy']['domain']}"
default['bind9-easy']['xmppserver'] = "xmpp.#{node['bind9-easy']['domain']}"
