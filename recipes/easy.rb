include_recipe 'bind9-easy::default'

bind9_easy_zone node['bind9-easy']['domain'] do
  email node['bind9-easy']['hostmaster_email']
  nameserver node['bind9-easy']['nameservers']
  mailserver ({ "@" => node['bind9-easy']['mailserver']})
  spf true
  xmpp node['bind9-easy']['xmppserver']
end
