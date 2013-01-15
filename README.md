# Description
Autoconfigures bind9 Server the easy way.

Implements a Zone LWRP searching chef and using user input to find all clients.

Supports
- Forwarders
- Transfer servers
- Custom zone entries
- Reverse zones

# Requirements
I am running on an ubuntu server - please report other platforms!

# Attributes

List of forwarders where requests should be forwarded to.
```ruby
default['bind']['forward'] = Array.new
```

List of servers where zone updates should be transferred to.
```ruby
default['bind']['transfer'] = Array.new
```

# Usage
Most complex setup:
```ruby
bind9_easy_zone "example.com" do
  email "hostmaster.example.com" #convert your emailaddress-@ into a .
  nameserver nses
  hosts ({
    "@" =>  "192.168.178.10",
    "not-a-chef-client" => "192.168.178.250", #results in a A record
    "my-hot-box" => "not-a-chef-client" #results in a CNAME record
  })
  mailserver "mail.example.com"
  xmpp "xmpp.example.com"
end

node.set['bind']['transfer'] = ["192.168.178.1","192.168.178.2"]
node.set['bind']['forward'] = ["172.0.0.1", "4.2.2.4"]

include_recipe "bind9"
```

Make sure to set up all zones, before calling the recipe.
Recipe writes named.conf.local and makes zones known to bind.

See resources/zone.rb for more zone-file attributes for bind9_easy_zone

# Ideas/TODO
- Add NS slave recipe
- Add ipv6

# Contact 
see metadata.rb

