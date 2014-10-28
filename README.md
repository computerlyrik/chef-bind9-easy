
[![Build Status](https://travis-ci.org/computerlyrik/chef-bind9-easy.png)](https://travis-ci.org/computerlyrik/chef-bind9-easy)

https://github.com/computerlyrik/chef-bind9-easy


# Description
Autoconfigures bind9 Server the easy way.

Never update your ID again!

Implements a Zone LWRP searching chef and using user input to find all clients.

Supports
- Forwarders
- Transfer servers
- Custom zone entries
- Reverse zones
- MX
- SPF
- XMPP-Entries

# Requirements
I am running on an ubuntu server - please report other platforms!

# Attributes

List of forwarders where requests should be forwarded to.
```ruby
default['bind9-easy']['forward'] = []

```

List of servers where zone updates should be transferred to.
```ruby
default['bind9-easy']['transfer'] = []
```

List of trusted servers allowed to query
```ruby
default['bind9-easy']['trusted_server'] = []
```

# Usage
## Easy Setup
Just include 
```ruby
bind9-easy::easy
```
in your run list.

This autoconfigures a basic setup for your current domain.
For more information see ```attributes/easy.rb``` and ```recipes/easy.rb```
Also try ```kitchen``` to see an example.

## Most complex setup:
```ruby
nameservers = ["ns.example.com", "ns1.first-ns.de", "robotns2.second-ns.de", "robotns3.second-ns.com" ]

# Configures a automatic zone - all chef clients in this domain will be added magically
bind9_easy_zone "example.com" do 
  email "hostmaster.example.com"
  nameserver nameservers
  hosts ({
    "@" =>  "192.168.2.1", #Generate an A Record
    "not-a-chef-client" => "192.168.178.250", #results in a A record
    "my-hot-box" => "not-a-chef-client" #results in a CNAME record
  })
  mailserver ({ "@" => "mail.example.com",
    "lists.example.com" => "lists.example.com"}) # another mailserver for subdomain
  spf true
  xmpp "xmpp.example.com" #Assuming xmpp is provided by automagic configuration
  subzones ({
    "lan.ns.example.com" => "ns.example.com",
    "v6.ns.example.com" => "ns.example.com",})
end

# generate a Subdomain-Zone for v6 Network
bind9_easy_zone "v6.example.com" do
  email "hostmaster.example.com"
  nameserver nameservers
end

# generate a Subdomain-Zone for internal nat
bind9_easy_zone "lan.example.com" do
  email "hostmaster.example.com"
  nameserver nameservers
  hosts ({
    "@" =>  "172.2.2.1",
  })
end
```

Make sure to set up all zones, before calling the recipe.
Recipe writes named.conf.local and makes zones known to bind.

See resources/zone.rb for more zone-file attributes for bind9_easy_zone

# Ideas/TODO
- Add NS slave recipe
- Add ipv6

# Contact 
see metadata.rb

