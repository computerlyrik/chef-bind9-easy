Description
===========

Autoconfigures bind9 Server.
Uses chef search and user input to find all clients.

Implements a Zone LWRP which sets up forward and reverse zones.


Requirements
============

I am running on an ubuntu server - please report other platforms!

Attributes
==========

node['bind']['id'] = Hash.new

default['bind']['forward'] = Array.new

List of forwarders (where requests should be forwarded to)


default['bind']['transfer'] = Array.new

List of servers where zone updates should be transferred to.

Usage
=====
Most complex setup:

bind9_zone "example.com" do
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


See resources/zone.rb for more attributes for bind9_zone

Ideas/TODO
==========

- Add NS slave recipe
- Add ipv6

